#!/usr/bin/env bash
prompt="$1"
if [[ "$prompt" == *▶* ]]; then
  echo "enable-search+change-prompt(⚡  )+reload(sesh list --icons)+clear-query"
else
  echo abort
fi
