#!/usr/bin/env bash

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select clipboard history. Press TAB to mark multiple items.'"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/.envs"

_tmux_fzf_action_system() {
  clipboard=$(copyq eval -- 'n=size(); for(i=0; i<n; i++) print("[" + str(i) + "] " + str(read(i)).split("\\").join("\\\\").split("\n").join("\\\\n")  + "\n")')
  clipboard_index=$(printf "$clipboard" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS --preview=\"printf {} | sed -E 's/^\[[0-9]+\] (.*)$/\1/'\"" | sed -E 's/^\[([0-9]+)\].*$/\1/')
  [[ -z "$clipboard_index" ]] && exit -1
  clipboard_contents=$(printf "$clipboard" | sed -n "$((clipboard_index+1))p" | sed -E 's/^\[[0-9]+\] (.*)$/\1/' | sed -E 's/\\\\/\\/g' | sed -E 's/\\n/\n/g' )
  tmux set-buffer -b _temp_tmux_fzf "$clipboard_contents" && tmux paste-buffer -b _temp_tmux_fzf && tmux delete-buffer -b _temp_tmux_fzf
}

_tmux_fzf_action_system
