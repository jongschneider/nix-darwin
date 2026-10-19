#!/usr/bin/env bash
# Refresh home/herdr/plugins/annotate-pins.json from the herdr-annotate source
# that flake.lock currently points at.
#
# annotate.nix stages the plugin's pinned release binaries itself (see
# WORKAROUNDS.md for why), and asserts upstream's own pins against the versions
# it fetches. That assert is deliberate — it stops a source bump from silently
# shipping an old binary — but it means every `nix flake update` that moves a
# pin breaks the build until the versions and per-platform hashes are updated.
# This does that from what the locked source says.
#
# Run it after `nix flake update` (`just update` already does). It reads the
# locked input rather than GitHub, so it repins to exactly the revision the lock
# will build, and is a no-op when nothing moved.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pins="$root/home/herdr/plugins/annotate-pins.json"

if [[ ! -f "$pins" ]]; then
    echo "no such pins file: $pins" >&2
    exit 1
fi

# The locked source, not the branch tip: whatever this says is what the next
# build will assert against.
src=$(nix eval --raw --impure --expr \
    "(builtins.getFlake \"path:$root\").inputs.herdr-annotate.outPath")

plugin_version=$(sed -n 's/^version = "\(.*\)"$/\1/p' "$src/herdr-plugin.toml" | head -1)
if [[ -z "$plugin_version" ]]; then
    echo "herdr-annotate: could not read the plugin version from $src/herdr-plugin.toml" >&2
    exit 1
fi

new=$(jq --arg v "$plugin_version" '.plugin = $v' "$pins")

for name in $(jq -r '.binaries | keys[]' "$pins"); do
    pinned=$(tr -d '[:space:]' <"$src/$name.version" 2>/dev/null || true)
    if [[ -z "$pinned" ]]; then
        echo "herdr-annotate: could not read $name.version from $src" >&2
        exit 1
    fi

    current=$(jq -r --arg n "$name" '.binaries[$n].version' "$pins")
    if [[ "$current" == "$pinned" ]]; then
        continue
    fi

    # One SHA256SUMS covers every asset, so the hashes cost one request rather
    # than a download per platform.
    release=$(jq -r --arg n "$name" '.binaries[$n].release' "$pins")
    sums_url="${release//\{version\}/$pinned}/SHA256SUMS"
    sums=$(curl -fsSL "$sums_url") || {
        echo "herdr-annotate: could not fetch $sums_url" >&2
        echo "  upstream pins $name $pinned — check that release exists" >&2
        exit 1
    }

    hashes="{}"
    while IFS=$'\t' read -r system rust_target; do
        hex=$(awk -v asset="$name-$rust_target" '$2 == asset { print $1 }' <<<"$sums")
        if [[ -z "$hex" ]]; then
            echo "herdr-annotate: $sums_url has no $name-$rust_target" >&2
            exit 1
        fi
        hash=$(nix hash convert --hash-algo sha256 --to sri "$hex")
        hashes=$(jq --arg s "$system" --arg h "$hash" '.[$s] = $h' <<<"$hashes")
        echo "  $name $rust_target $hash"
    done < <(jq -r '.targets | to_entries[] | "\(.key)\t\(.value)"' "$pins")

    new=$(jq --arg n "$name" --arg v "$pinned" --argjson h "$hashes" \
        '.binaries[$n].version = $v | .binaries[$n].hashes = $h' <<<"$new")
    echo "herdr-annotate: $name ${current:-none} -> $pinned (hashes from $sums_url)"
done

if [[ "$new" == "$(jq . "$pins")" ]]; then
    echo "herdr-annotate: already at $plugin_version"
    exit 0
fi

printf '%s\n' "$new" >"$pins"
echo "herdr-annotate: pins updated for plugin $plugin_version"
echo "  run 'just c' before committing — check min_herdr_version too if the plugin fails to load"
