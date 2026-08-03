#!/usr/bin/env bash
# Repin scripts/<derivation>.nix to the version npm tags as latest.
#
# Nix can't resolve "latest" at eval time — a fixed-output derivation needs the
# hash up front — so the pin is bumped here and committed, which keeps rebuilds
# reproducible in between updates.
#
# Two shapes are handled. A derivation that fetches one tarball just gets its
# lone `hash` replaced. A derivation that fetches a different tarball per
# platform declares an `npmArch` beside each `hash`, and every one is refetched;
# such a package usually also sets `npmPackage`, since the registry entry it
# takes its version from ("@yaakapp/cli") is not the derivation's file name.
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "usage: ${0##*/} <derivation-name>" >&2
    exit 64
fi

derivation="$1"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
file="$root/scripts/$derivation.nix"

if [[ ! -f "$file" ]]; then
    echo "no such derivation: $file" >&2
    exit 1
fi

package=$(sed -n 's/^  npmPackage = "\(.*\)";$/\1/p' "$file")
package="${package:-$derivation}"

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

# A scoped name keeps the scope in the registry path but loses it in the
# tarball's own filename: @yaakapp/cli -> /@yaakapp/cli/-/cli-<version>.tgz
tarball_url() {
    printf 'https://registry.npmjs.org/%s/-/%s-%s.tgz' "$1" "${1##*/}" "$latest"
}

arches=$(sed -n 's/^ *npmArch = "\(.*\)";$/\1/p' "$file")

hashes=""
if [[ -z "$arches" ]]; then
    url=$(tarball_url "$package")
    hashes=$(nix store prefetch-file --json --refresh "$url" | jq -r .hash)
    echo "  $package $hashes"
else
    # In file order, so the awk pass below can pair them off against the
    # npmArch lines it walks.
    while read -r arch; do
        url=$(tarball_url "$package-$arch")
        hash=$(nix store prefetch-file --json --refresh "$url" | jq -r .hash)
        hashes="$hashes $hash"
        echo "  $package-$arch $hash"
    done <<<"$arches"
fi

# Not sed -i: BSD and GNU sed disagree on whether it takes a suffix argument.
awk -v version="$latest" -v hashes="$hashes" '
BEGIN { count = split(hashes, hash, " "); seen = 0 }
/^  version = ".*";$/ { sub(/"[^"]*"/, "\"" version "\"") ; print ; next }
/^ *npmArch = ".*";$/ { seen++ ; print ; next }
/^ *hash = ".*";$/ {
    # Single-tarball derivations have no npmArch lines, so seen stays 0 and the
    # one hash is index 1; multi-arch ones take the hash for the arch above.
    i = (count > 1 ? seen : 1)
    if (i >= 1 && i <= count) sub(/"[^"]*"/, "\"" hash[i] "\"")
    print ; next
}
{ print }
' "$file" >"$file.tmp"
mv "$file.tmp" "$file"

echo "$derivation: $current -> $latest"
echo "  run 'just c' before committing — a new upstream version can always break the build"
