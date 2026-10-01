#!/bin/sh

# Network plugin: icon for the interface carrying the default route, label = its local IP.
# ponytail: no SSID, macOS redacts it for scripts without Location Services permission.

iface="$(/sbin/route -n get default 2>/dev/null | /usr/bin/awk '/interface:/ { print $2; exit }')"
wifi_iface="$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/awk '/Wi-Fi/ { getline; print $2; exit }')"
ip="$([ -n "$iface" ] && /usr/sbin/ipconfig getifaddr "$iface")"

if [ -z "$ip" ]; then
    sketchybar --set "$NAME" icon="󰖪" label="offline"
elif [ "$iface" = "$wifi_iface" ]; then
    sketchybar --set "$NAME" icon="󰖩" label="$ip"
else
    sketchybar --set "$NAME" icon="󰈀" label="$ip"
fi
