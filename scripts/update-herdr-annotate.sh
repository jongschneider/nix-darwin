#!/usr/bin/env bash
# Refresh home/herdr/plugins/annotate.nix from the herdr-annotate source that
# flake.lock currently points at.
#
# annotate.nix stages a pinned plannotator-tui release binary itself (see
# WORKAROUNDS.md for why), and asserts upstream's own pin against the version it
# fetches. That assert is deliberate — it stops a source bump from silently
# shipping the old binary — but it means every `nix flake update` that moves the
# pin breaks the build until three things are hand-edited: the plannotator-tui
# version, the four per-platform hashes, and the plugin's own version. This does
# all three from what the locked source says.
#
# Run it after `nix flake update` (`just update` already does). It reads the
# locked input rather than GitHub, so it repins to exactly the revision the lock
# will build, and is a no-op when nothing moved.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
file="$root/home/herdr/plugins/annotate.nix"

if [[ ! -f "$file" ]]; then
    echo "no such derivation: $file" >&2
    exit 1
fi

# The locked source, not the branch tip: whatever this says is what the next
# build will assert against.
src=$(nix eval --raw --impure --expr \
    "(builtins.getFlake \"path:$root\").inputs.herdr-annotate.outPath")

pinned=$(tr -d '[:space:]' <"$src/plannotator-tui.version")
plugin_version=$(sed -n 's/^version = "\(.*\)"$/\1/p' "$src/herdr-plugin.toml" | head -1)

if [[ -z "$pinned" || -z "$plugin_version" ]]; then
    echo "herdr-annotate: could not read plannotator-tui.version / herdr-plugin.toml from $src" >&2
    exit 1
fi

# The pin lives in the `let` block (two spaces), the plugin's own version in the
# mkDerivation attrs (four).
current_pin=$(sed -n 's/^  version = "\(.*\)";$/\1/p' "$file")
current_plugin=$(sed -n 's/^    version = "\(.*\)";$/\1/p' "$file")

if [[ "$current_pin" == "$pinned" && "$current_plugin" == "$plugin_version" ]]; then
    echo "herdr-annotate: already at $plugin_version (plannotator-tui $pinned)"
    exit 0
fi

# One SHA256SUMS covers every asset, so the hashes cost one request rather than
# four downloads — the same source the file's comment tells a human to use.
sums_url="https://github.com/plannotator/plannotator-tui/releases/download/v$pinned/SHA256SUMS"
sums=$(curl -fsSL "$sums_url") || {
    echo "herdr-annotate: could not fetch $sums_url" >&2
    echo "  upstream pins plannotator-tui $pinned — check that release exists" >&2
    exit 1
}

# In file order, so the awk pass below can pair them off against the rustTarget
# lines it walks.
hashes=""
while read -r rust_target; do
    hex=$(awk -v asset="plannotator-tui-$rust_target" '$2 == asset { print $1 }' <<<"$sums")
    if [[ -z "$hex" ]]; then
        echo "herdr-annotate: $sums_url has no plannotator-tui-$rust_target" >&2
        exit 1
    fi
    hash=$(nix hash convert --hash-algo sha256 --to sri "$hex")
    hashes="$hashes $hash"
    echo "  $rust_target $hash"
done < <(sed -n 's/^      rustTarget = "\(.*\)";$/\1/p' "$file")

if [[ -z "$hashes" ]]; then
    echo "herdr-annotate: found no rustTarget entries in $file" >&2
    exit 1
fi

# Not sed -i: BSD and GNU sed disagree on whether it takes a suffix argument.
awk -v pin="$pinned" -v plugin="$plugin_version" -v hashes="$hashes" '
BEGIN { count = split(hashes, hash, " "); seen = 0 }
/^  version = ".*";$/ { sub(/"[^"]*"/, "\"" pin "\"") ; print ; next }
/^    version = ".*";$/ { sub(/"[^"]*"/, "\"" plugin "\"") ; print ; next }
/^      rustTarget = ".*";$/ { seen++ ; print ; next }
/^      hash = ".*";$/ {
    if (seen >= 1 && seen <= count) sub(/"[^"]*"/, "\"" hash[seen] "\"")
    print ; next
}
{ print }
' "$file" >"$file.tmp"
mv "$file.tmp" "$file"

echo "herdr-annotate: $current_plugin -> $plugin_version (plannotator-tui $current_pin -> $pinned)"
echo "  hashes from $sums_url"
echo "  run 'just c' before committing — check min_herdr_version too if the plugin fails to load"
