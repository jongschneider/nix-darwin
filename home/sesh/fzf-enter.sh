#!/usr/bin/env bash
prompt="$1"
query="$2"
if [[ "$prompt" == *▶* ]]; then
  session="${prompt#✏️  }"
  session="${session% ▶ }"
  tmux rename-session -t "$session" "$query" 2>/dev/null
  echo "enable-search+change-prompt(⚡  )+reload(sesh list --icons)+clear-query"
else
  echo accept
fi
