#!/usr/bin/env bash
# Rename a freshly created workspace to its git repository name.
#
# Herdr's built-in auto-name comes from the checkout directory's basename. For a
# linked worktree that's the worktree folder (often the branch, e.g. "master"),
# not the repo. This hook resolves the shared repo name instead and sets it as
# the workspace's custom name. The git branch already renders on the sidebar's
# second line, so the result is: line 1 = repo, line 2 = branch.
#
# It only runs on creation events, so it never clobbers a name you set by hand
# later.
set -euo pipefail

ctx="${HERDR_PLUGIN_CONTEXT_JSON:-}"
[ -n "$ctx" ] || exit 0

ws_id="$(printf '%s' "$ctx" | jq -r '.workspace_id // empty')"
[ -n "$ws_id" ] || ws_id="${HERDR_WORKSPACE_ID:-}"
[ -n "$ws_id" ] || exit 0

# Prefer the repo name Herdr already resolved for worktree-backed workspaces.
name="$(printf '%s' "$ctx" | jq -r '.worktree.repo_name // empty')"

# Otherwise derive it from the workspace cwd, worktree-aware: the repo name is
# the parent directory of the shared common git dir (.git), which is the same
# for the main checkout and every linked worktree.
if [ -z "$name" ]; then
  cwd="$(printf '%s' "$ctx" | jq -r '.workspace_cwd // .focused_pane_cwd // empty')"
  [ -n "$cwd" ] || exit 0

  common="$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null || true)"
  [ -n "$common" ] || exit 0   # not a git repo: leave the default name alone
  case "$common" in
    /*) : ;;                    # already absolute
    *)  common="$cwd/$common" ;; # git may return it relative to cwd
  esac

  if [ "$(basename "$common")" = ".git" ]; then
    name="$(basename "$(dirname "$common")")"
  else
    # bare repo: the common dir is the repo dir itself
    name="$(basename "$common")"
    name="${name%.git}"
  fi
fi

[ -n "$name" ] || exit 0

herdr="${HERDR_BIN_PATH:-herdr}"
exec "$herdr" workspace rename "$ws_id" "$name"
