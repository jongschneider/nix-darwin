#!/bin/bash
# Check if we're in a worktree
if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [[ "$(git rev-parse --git-dir)" != ".git" ]]; then
    # Worktree version
    git -C "$(git rev-parse --show-toplevel)" status --porcelain |
        awk '{print $2}' |
        while read -r file; do
            if [[ "$file" =~ \.go$ ]] || grep -q "^package " "$file" 2>/dev/null; then
                echo "./$(dirname "$file")/..."
            fi
        done |
        sort |
        uniq |
        xargs -r go test --failfast
else
    # Regular repository version
    git status --porcelain |
        awk '{print $2}' |
        while read -r file; do
            echo "./$(dirname "$file")/..."
        done |
        sort |
        uniq |
        tr '\n' ' ' |
        xargs go test --failfast
fi
