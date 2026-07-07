#!/usr/bin/env bash
# sesh-style popup picker for herdr: fzf over open workspaces + zoxide dirs.
# Bound to prefix+t via [[keys.command]] (type = "pane") in config.toml.
set -euo pipefail

list_entries() {
  herdr workspace list | jq -r '
    .result.workspaces[]
    | ["[38;2;166;227;161m󰆍[0m  \(.label)", "ws", .workspace_id, .label] | @tsv
  '
  zoxide query -l | while IFS= read -r dir; do
    printf '[38;2;137;180;250m󰉋[0m %s\t%s\t%s\t%s\n' "$dir" "dir" "$dir" "$dir"
  done
}

# Complex piped commands inline in fzf's --preview/--bind strings are unreliable
# in herdr's overlay panes (herdr | jq output silently vanishes); delegating to
# this script's own modes avoids that.
case "${1:-}" in
  --preview)
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
    ;;
  --list)
    list_entries
    exit 0
    ;;
  --rename-prompt)
    kind="$2"
    id="$3"
    name="$4"
    if [[ "$kind" == "ws" ]]; then
      printf 'change-prompt(rename:%s ▶ )+change-query(%s)+disable-search' "$id" "$name"
    fi
    exit 0
    ;;
  --enter)
    prompt="$2"
    query="$3"
    if [[ "$prompt" == rename:* ]]; then
      id="${prompt#rename:}"
      id="${id%% *}"
      herdr workspace rename "$id" "$query" >/dev/null
      echo "enable-search+change-prompt(⚡  )+reload(~/.config/herdr/session-picker.sh --list)+clear-query"
    else
      echo accept
    fi
    exit 0
    ;;
  --close)
    kind="$2"
    id="$3"
    [[ "$kind" == "ws" ]] && herdr workspace close "$id" >/dev/null
    exit 0
    ;;
esac

selected=$(
  list_entries | fzf --no-sort --ansi --border-label ' herdr ' --prompt '⚡  ' \
    --header '  enter: focus/create   ^r rename   ^d close   ^y copy ▶ ' \
    --delimiter '\t' --with-nth 1 \
    --preview '~/.config/herdr/session-picker.sh --preview {2} {3}' \
    --preview-window 'right:55%' \
    --bind 'ctrl-r:transform:~/.config/herdr/session-picker.sh --rename-prompt {2} {3} {4}' \
    --bind 'enter:transform:~/.config/herdr/session-picker.sh --enter {fzf:prompt} {q}' \
    --bind 'ctrl-d:execute-silent(~/.config/herdr/session-picker.sh --close {2} {3})+reload(~/.config/herdr/session-picker.sh --list)' \
    --bind 'ctrl-y:execute-silent(printf %s {4} | pbcopy)'
)

[[ -z "$selected" ]] && exit 0

kind=$(printf '%s' "$selected" | cut -f2)
value=$(printf '%s' "$selected" | cut -f3)

if [[ "$kind" == "ws" ]]; then
  herdr workspace focus "$value"
else
  herdr workspace create --cwd "$value" --label "$(basename "$value")" --focus
fi
