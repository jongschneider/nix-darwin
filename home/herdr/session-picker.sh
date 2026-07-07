#!/usr/bin/env bash
# sesh-style popup picker for herdr: fzf over open workspaces + zoxide dirs.
# Bound to prefix+t via [[keys.command]] (type = "pane") in config.toml.
set -euo pipefail

# Complex piped commands inline in fzf's --preview string are unreliable in
# herdr's overlay panes (herdr | jq output silently vanishes); delegating to
# this script's own --preview mode avoids that.
if [[ "${1:-}" == "--preview" ]]; then
  kind="$2"
  value="$3"
  case "$kind" in
    ws)
      pane_id=$(herdr pane list | jq -r --arg ws "$value" '.result.panes[] | select(.workspace_id == $ws) | .pane_id' | head -1)
      [[ -n "$pane_id" ]] && herdr pane read "$pane_id" --source visible --format ansi
      ;;
    dir)
      eza --all --git --icons --color=always "$value"
      ;;
  esac
  exit 0
fi

list_entries() {
  herdr workspace list | jq -r '
    .result.workspaces[]
    | ["[38;2;166;227;161m󰆍[0m  \(.label)", "ws", .workspace_id] | @tsv
  '
  zoxide query -l | while IFS= read -r dir; do
    printf '[38;2;137;180;250m󰉋[0m %s\t%s\t%s\n' "$dir" "dir" "$dir"
  done
}

selected=$(
  list_entries | fzf --no-sort --ansi --border-label ' herdr ' --prompt '⚡  ' \
    --header '  enter: focus/create ▶ ' \
    --delimiter '\t' --with-nth 1 \
    --preview '~/.config/herdr/session-picker.sh --preview {2} {3}' \
    --preview-window 'right:55%'
)

[[ -z "$selected" ]] && exit 0

kind=$(printf '%s' "$selected" | cut -f2)
value=$(printf '%s' "$selected" | cut -f3)

if [[ "$kind" == "ws" ]]; then
  herdr workspace focus "$value"
else
  herdr workspace create --cwd "$value" --label "$(basename "$value")" --focus
fi
