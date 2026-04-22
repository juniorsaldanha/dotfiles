#!/usr/bin/env zsh
# ~/.config/aerospace/toggle-claude.sh

export PATH="/opt/homebrew/bin:$PATH"

OUTPUT=$(aerospace-scratchpad show Claude 2>&1)

if echo "$OUTPUT" | grep -q 'result=not-found'; then
    open -a Claude
else
    ACTION=$(echo "$OUTPUT" | grep -o 'action=[^ ]*' | cut -d= -f2)
    if [ "$ACTION" != "focus" ]; then
        aerospace-scratchpad move
    fi
fiii
