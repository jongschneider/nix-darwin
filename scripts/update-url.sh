#!/usr/bin/env bash
# Repin scripts/<package>.nix to whatever its src URL serves right now.
#
# For derivations tracking a moving target (a branch tip, an unversioned path)
# rather than a release: the URL never changes, only its contents. Nix caches by
# hash, so a stale pin stays invisible until a fresh machine or a GC'd store
# refetches and fails on the mismatch. Repinning at update time turns that
# ambush into a reviewable diff.
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "usage: ${0##*/} <derivation-name>" >&2
    exit 64
fi

package="$1"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
file="$root/scripts/$package.nix"

if [[ ! -f "$file" ]]; then
    echo "no such derivation: $file" >&2
    exit 1
fi

# Ask nix for the URL rather than scraping it out of the file: the attr may
# interpolate, as it does for the npm-pinned derivations.
url=$(nix eval --raw --impure --expr \
    "(import $file { pkgs = import (builtins.getFlake \"path:$root\").inputs.nixpkgs { system = builtins.currentSystem; }; }).src.url")

current=$(sed -n 's/^    hash = "\(.*\)";$/\1/p' "$file")
latest=$(nix store prefetch-file --json --refresh "$url" | jq -r .hash)

if [[ "$current" == "$latest" ]]; then
    echo "$package: unchanged"
    echo "  $url"
    exit 0
fi

sed -e "s|^    hash = \".*\";\$|    hash = \"$latest\";|" "$file" >"$file.tmp"
mv "$file.tmp" "$file"

echo "$package: repinned $url"
echo "  was $current"
echo "  now $latest"
echo "  upstream contents changed — run 'just c' and skim what moved before committing"
echo "  note: the 'version' attr is not derivable from the URL and was left alone"
