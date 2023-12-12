#!/usr/bin/env bash

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select clipboard history.'"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/.envs"

_tmux_fzf_action_system() {
  local RX_CONTENTS='s/^\[[0-9]+\] (.*)$/\1/'
  local RX_INDEX='s/^\[([0-9a-z]+)\].*$/\1/'

  local clipboard="$(cat "$CURRENT_DIR/copyq_read_tab_0.js" | copyq eval -)"
  local clipboard_index=$(printf "$clipboard\n[cancel]" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS --preview=\"printf {} | sed -E '${RX_CONTENTS}'\"" | sed -E "$RX_INDEX")
  [[ clipboard_index == "[cancel]" || -z "$clipboard_index" ]] && exit
  local clipboard_contents="$(printf "$clipboard_index" | xargs sh -c 'printf "$1" | sed -n "$(($3 + 1))p" | sed -E "$2" | sed -E '"'s/\\\\\\\\/\\\\/g'"' | sed -E '"'s/\\\\n/\\n/g'" -- "$clipboard" "$RX_CONTENTS")"
  tmux set-buffer -b _temp_tmux_fzf "$clipboard_contents" && tmux paste-buffer -b _temp_tmux_fzf && tmux delete-buffer -b _temp_tmux_fzf
}

_tmux_fzf_action_system
