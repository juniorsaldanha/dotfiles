bindkey -v # bind vi keybinds (Esc to enter command mode)
bindkey "^R" history-incremental-search-backward
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey "^[[1;2D" backward-word
bindkey "^[[1;2C" forward-word
bindkey "^[[1;2B" beggining-of-line
bindkey "^[[1;2A" end-of-line
bindkey -s ^a "nvims\n"
