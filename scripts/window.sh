#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ACTION=$(printf "kill\nrename\nswitch\n[cancel]" | "$CURRENT_DIR/.fzf-tmux")
if [[ "$ACTION" == "[cancel]" ]]; then
    exit
else
    TARGET_ORIGIN=$(printf "$(tmux list-windows -a)\n[cancel]" | "$CURRENT_DIR/.fzf-tmux")
    if [[ "$TARGET_ORIGIN" == "[cancel]" ]]; then
        exit
    else
        TARGET=$(echo "$TARGET_ORIGIN" | grep -o '[[:alpha:]]*:[[:digit:]]*:' | sed 's/.$//g')
        if [[ "$ACTION" == "kill" ]]; then
            echo "$TARGET" | xargs tmux kill-window -t
        elif [[ "$ACTION" == "rename" ]]; then
            tmux command-prompt -I "rename-window -t $TARGET "
        elif [[ "$ACTION" == "switch" ]]; then
            echo "$TARGET" | sed 's/:.*//g' | xargs tmux switch-client -t
            echo "$TARGET" | xargs tmux select-window -t
        fi
    fi
fi
