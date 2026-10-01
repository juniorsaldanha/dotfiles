#!/bin/sh

# GPU usage plugin (Apple Silicon / any IOAccelerator).
# Reads "Device Utilization %" from IOKit (same source as Activity Monitor's GPU History).
# ponytail: btop uses IOReport residency (private API); this can differ by a few % from btop.

percent="$(/usr/sbin/ioreg -r -d 1 -c IOAccelerator | /usr/bin/awk -F'"Device Utilization %"=' 'NF > 1 { split($2, a, /[^0-9]/); print a[1]; exit }')"

case "$percent" in
'' | *[!0-9]*) percent=0 ;;
esac

sketchybar --set gpu_usage label="${percent}%"
