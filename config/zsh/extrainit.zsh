# Used in system/shared/home-manager.nix

license () {
  curl -L "api.github.com/licenses/$1" | jq -r .body > LICENSE
}

gitignore () {
  curl -sL "toptal.com/developers/gitignore/api/$@" > .gitignore
}

n () {
  if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

  nnn -adeHo "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}

newt () {
  has_existing="$(git branch -v | grep -e " ${1} ")"

  git_flags=""

  if [[ "$has_existing" == "" ]]; then
    git_flags="-b"
  fi

  git worktree add "${git_flags}" "${1}" "${1}"
}

if [[ -d "/opt/homebrew" ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi
