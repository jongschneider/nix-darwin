#!/usr/bin/env bash
# Repin scripts/<package>.nix to the version npm tags as latest.
#
# Nix can't resolve "latest" at eval time — a fixed-output derivation needs the
# hash up front — so the pin is bumped here and committed, which keeps rebuilds
# reproducible in between updates.
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "usage: ${0##*/} <npm-package-name>" >&2
    exit 64
fi

package="$1"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
file="$root/scripts/$package.nix"

if [[ ! -f "$file" ]]; then
    echo "no such derivation: $file" >&2
    exit 1
fi

current=$(sed -n 's/^  version = "\(.*\)";$/\1/p' "$file")
latest=$(curl -fsS "https://registry.npmjs.org/$package" | jq -r '."dist-tags".latest')

if [[ -z "$latest" || "$latest" == "null" ]]; then
    echo "$package: could not read dist-tags.latest from the npm registry" >&2
    exit 1
fi

if [[ "$current" == "$latest" ]]; then
    echo "$package: already at $latest"
    exit 0
fi

url="https://registry.npmjs.org/$package/-/$package-$latest.tgz"
hash=$(nix store prefetch-file --json --refresh "$url" | jq -r .hash)

# Not sed -i: BSD and GNU sed disagree on whether it takes a suffix argument.
sed -e "s|^  version = \".*\";\$|  version = \"$latest\";|" \
    -e "s|^    hash = \".*\";\$|    hash = \"$hash\";|" \
    "$file" >"$file.tmp"
mv "$file.tmp" "$file"

echo "$package: $current -> $latest"
echo "  $hash"
echo "  run 'just c' before committing — a new upstream version can always break the build"
