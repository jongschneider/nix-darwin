#!/usr/bin/env bash
# Audit the third-party Homebrew taps this config pins against.
#
# A tap-qualified brew ("modem-dev/tap/hunk") is a standing bet that the tap
# keeps bumping its formula. When the tap stops -- because the package
# graduated into homebrew-core and the vendor tap was abandoned, or because a
# bump landed, got reverted, and was never redone -- every step of the normal
# update path still reports success: `brew update` refreshes the tap, `brew
# outdated` finds nothing, `brew upgrade` has nowhere to go. The pin rots in
# silence, and the only symptom is a version that stopped moving months ago.
#
# This is the check that notices. It compares what the current host's config
# asks for against homebrew-core and against each project's own releases, so a
# frozen tap surfaces as a finding at update time instead of a surprise later.
set -euo pipefail

strict=0
host=""
for arg in "$@"; do
    case "$arg" in
    --strict) strict=1 ;;
    -h | --help)
        echo "usage: ${0##*/} [--strict] [hostname]"
        echo "  --strict   exit 1 if anything needs attention"
        exit 0
        ;;
    -*)
        echo "unknown flag: $arg" >&2
        exit 64
        ;;
    *) host="$arg" ;;
    esac
done

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "brew-audit: not macOS, nothing to audit"
    exit 0
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
host="${host:-$(scutil --get LocalHostName)}"

# Findings accumulate here so the report can be grouped by kind rather than by
# whatever order the packages happen to come back in.
declare -a shadowed=() behind=() orphans=() undeclared=()

cfg() { nix eval --json "$root#darwinConfigurations.\"$host\".config.homebrew.$1" 2>/dev/null; }

declared_brews=$(cfg brews | jq -r '.[].name')
declared_casks=$(cfg casks | jq -r '.[].name')
declared_taps=$(cfg taps | jq -r '.[].name')

if [[ -z "$declared_brews$declared_casks$declared_taps" ]]; then
    echo "brew-audit: could not evaluate homebrew config for host '$host'" >&2
    exit 1
fi

inventory=$(brew info --json=v2 --installed 2>/dev/null)

# The declared side comes from whichever host was asked for; the installed side
# can only ever be this machine. Naming another host still tells you something
# about its taps, just nothing about its versions.
if [[ "$host" != "$(scutil --get LocalHostName)" ]]; then
    echo "note: comparing $host's config against THIS machine's installed packages;" >&2
    echo "      only the tap-usage check is meaningful across hosts" >&2
fi

# Strip a leading "v" so tap versions and git tags compare on equal terms.
ver() { sed 's/^[vV]//' <<<"${1:-}"; }

# True when $1 sorts strictly before $2. Both /usr/bin/sort and gsort take -V.
version_lt() {
    [[ "$1" != "$2" ]] && [[ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" == "$1" ]]
}

# owner/repo out of any github.com URL, or nothing.
gh_repo() {
    sed -nE 's#^https?://github\.com/([^/]+)/([^/?#]+).*#\1/\2#p' <<<"${1:-}" | sed 's/\.git$//' | head -1
}

# Newest release tag a project has published. `gh` carries the user's token, so
# it dodges the 60-requests-an-hour ceiling curl would hit.
gh_latest() {
    local repo="$1"
    [[ -z "$repo" ]] && return 0
    if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
        gh api "repos/$repo/releases/latest" --jq '.tag_name // empty' 2>/dev/null || true
    else
        curl -fsSL "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null |
            jq -r '.tag_name // empty' 2>/dev/null || true
    fi
}

# Days since the tap last touched this package's formula. A tap can look alive
# from its commit log while the one file we depend on has not moved in months.
formula_age_days() {
    local tap="$1" name="$2" repo file
    repo=$(brew --repo "$tap" 2>/dev/null) || return 0
    [[ -d "$repo/.git" ]] || return 0
    file=$(git -C "$repo" ls-files "*/$name.rb" "$name.rb" 2>/dev/null | head -1)
    [[ -n "$file" ]] || return 0
    local ts
    ts=$(git -C "$repo" log -1 --format=%ct -- "$file" 2>/dev/null) || return 0
    [[ -n "$ts" ]] || return 0
    echo $(((($(date +%s) - ts)) / 86400))
}

# --- tap-sourced packages: is core ahead, or is the tap behind upstream? ------

while IFS=$'\t' read -r kind name tap installed homepage url; do
    [[ -z "$name" ]] && continue

    # Does the maintained core/cask tap ship this too? If so the pin is a
    # liability: core is bottled and bumped by people who do it full time.
    core_tap="homebrew/core"
    info_flag="--formula"
    [[ "$kind" == cask ]] && core_tap="homebrew/cask" && info_flag="--cask"

    core_ver=$(brew info --json=v2 "$info_flag" "$core_tap/$name" 2>/dev/null |
        jq -r 'first((.formulae[]?.versions.stable), (.casks[]?.version)) // empty' 2>/dev/null || true)

    if [[ -n "$core_ver" ]]; then
        note="core $core_ver vs $tap $installed"
        version_lt "$(ver "$installed")" "$(ver "$core_ver")" && note="$note -- core is AHEAD"
        shadowed+=("$name ($kind): $note")
    fi

    # Independently of core, has the project itself moved past what the tap serves?
    latest=$(gh_latest "$(gh_repo "$homepage")")
    [[ -z "$latest" ]] && latest=$(gh_latest "$(gh_repo "$url")")
    if [[ -n "$latest" ]] && version_lt "$(ver "$installed")" "$(ver "$latest")"; then
        age=$(formula_age_days "$tap" "$name")
        detail="upstream $(ver "$latest") vs $tap $installed"
        [[ -n "$age" ]] && detail="$detail (formula untouched for ${age}d)"
        behind+=("$name ($kind): $detail")
    fi
done < <(jq -r '
    (.formulae[]? | select(.tap != "homebrew/core")
        | ["formula", .name, .tap, (.installed[0].version // ""), (.homepage // ""), (.urls.stable.url // "")]),
    (.casks[]? | select(.tap != "homebrew/cask")
        | ["cask", .token, .tap, (.installed // .version // ""), (.homepage // ""), (.url // "")])
    | @tsv' <<<"$inventory")

# --- taps nothing installs from -----------------------------------------------

while read -r tap; do
    [[ -z "$tap" ]] && continue
    if ! printf '%s\n%s\n' "$declared_brews" "$declared_casks" | grep -qF "$tap/"; then
        orphans+=("$tap")
    fi
done <<<"$declared_taps"

# --- installed on purpose but absent from the config --------------------------
#
# `cleanup = "zap"` removes anything the Brewfile does not list, so these
# disappear on the next switch. Usually that is correct and the point of zap;
# it is worth seeing before it happens rather than after.
while IFS=$'\t' read -r kind name full; do
    [[ -z "$name" ]] && continue
    if ! printf '%s\n%s\n' "$declared_brews" "$declared_casks" | grep -qxF -e "$name" -e "$full"; then
        undeclared+=("$name ($kind)")
    fi
done < <(jq -r '
    (.formulae[]? | select(.installed[0].installed_on_request) | ["formula", .name, .full_name]),
    (.casks[]? | ["cask", .token, .full_token])
    | @tsv' <<<"$inventory")

# --- report -------------------------------------------------------------------

section() {
    local title="$1" fix="$2"
    shift 2
    [[ $# -eq 0 ]] && return 0
    printf '\n%s\n' "$title"
    printf '  %s\n' "$@"
    printf '  fix: %s\n' "$fix"
}

echo "brew-audit: $host"

section "also in homebrew-core (drop the tap qualifier):" \
    "list the bare name in brews/casks, remove the tap, then 'brew uninstall <name> && brew install <name>'" \
    "${shadowed[@]+"${shadowed[@]}"}"

section "tap is behind the project's own releases:" \
    "the tap has stopped bumping -- move to core if it is there, or vendor the version yourself" \
    "${behind[@]+"${behind[@]}"}"

section "taps nothing installs from:" \
    "remove from homebrew.taps" \
    "${orphans[@]+"${orphans[@]}"}"

section "installed on request but not in the config (zap will remove these):" \
    "add to brews/casks to keep, or let the next switch take them" \
    "${undeclared[@]+"${undeclared[@]}"}"

findings=$((${#shadowed[@]} + ${#behind[@]} + ${#orphans[@]} + ${#undeclared[@]}))
if [[ $findings -eq 0 ]]; then
    echo "  every tap pin is current and every tap is in use"
    exit 0
fi

printf '\n%d finding(s)\n' "$findings"
[[ $strict -eq 1 ]] && exit 1
exit 0
