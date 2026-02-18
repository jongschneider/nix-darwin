#!/usr/bin/env bash
selected=$(
  sesh list --icons | fzf-tmux -p 80%,70% \
    --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
    --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^r rename ^f find' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)+enable-search' \
    --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)+enable-search' \
    --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)+enable-search' \
    --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)+enable-search' \
    --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)+enable-search' \
    --bind 'ctrl-r:transform:name={2..}; echo "change-prompt(✏️  $name ▶ )+change-query($name)+disable-search"' \
    --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
    --bind 'enter:transform:~/.config/sesh/fzf-enter.sh {fzf:prompt} {q}' \
    --bind 'esc:transform:~/.config/sesh/fzf-esc.sh {fzf:prompt}' \
    --preview-window 'right:55%' \
    --preview 'sesh preview {}'
)

[[ -n "$selected" ]] && sesh connect "$selected"
exit 0
