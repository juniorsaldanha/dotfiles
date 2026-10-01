#!/bin/sh

# Volume plugin. The volume_change event passes the new level (0-100) in $INFO.

VOLUME="$INFO"
if [ -z "$VOLUME" ]; then
    VOLUME="$(osascript -e 'output volume of (get volume settings)')"
fi

case "$VOLUME" in
[6-9][0-9] | 100) ICON="󰕾" ;;
[3-5][0-9]) ICON="󰖀" ;;
[1-9] | [1-2][0-9]) ICON="󰕿" ;;
*) ICON="󰖁" ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
