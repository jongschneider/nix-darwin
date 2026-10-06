#!/usr/bin/env bash
# Rename a freshly created workspace to its git repository name.
#
# Herdr's built-in auto-name comes from the checkout directory's basename. This
# hook resolves the repo name instead and sets it as the workspace's custom
# name. The git branch already renders on the sidebar's second line, so the
# result is: line 1 = repo, line 2 = branch.
#
# Linked worktrees are left alone. Every worktree of a repo would get the same
# name, and the new-workspace skill names them after their branch right after
# opening them — a rename this hook would race and overwrite.
#
# It only runs on creation events, so it never clobbers a name you set by hand
# later.
set -euo pipefail

ctx="${HERDR_PLUGIN_CONTEXT_JSON:-}"
[ -n "$ctx" ] || exit 0

ws_id="$(printf '%s' "$ctx" | jq -r '.workspace_id // empty')"
[ -n "$ws_id" ] || ws_id="${HERDR_WORKSPACE_ID:-}"
[ -n "$ws_id" ] || exit 0

[ "$(printf '%s' "$ctx" | jq -r '.worktree.is_linked_worktree // false')" = "true" ] && exit 0

cwd="$(printf '%s' "$ctx" | jq -r '.workspace_cwd // .focused_pane_cwd // empty')"

# The context may not carry worktree info, so ask git too: only a linked
# worktree has a git dir that differs from the shared common dir.
if [ -n "$cwd" ]; then
  gitdir="$(git -C "$cwd" rev-parse --path-format=absolute --git-dir 2>/dev/null || true)"
  commondir="$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
  [ -n "$gitdir" ] && [ "$gitdir" != "$commondir" ] && exit 0
fi

# Prefer the repo name Herdr already resolved for worktree-backed workspaces.
name="$(printf '%s' "$ctx" | jq -r '.worktree.repo_name // empty')"

# Otherwise derive it from the workspace cwd: the repo name is the parent
# directory of the common git dir (.git).
if [ -z "$name" ]; then
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
