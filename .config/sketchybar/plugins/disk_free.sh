#!/bin/sh

# Show available disk space as PERCENT FREE for the Data volume.
# We intentionally use native macOS `df` output so it matches tools like `ds`.

# Prefer the Data volume on modern macOS; fallback to /.
mount_point="/System/Volumes/Data"
if [ ! -d "$mount_point" ]; then
    mount_point="/"
fi

# df -k format: Filesystem 1K-blocks Used Available Capacity iused ifree %iused Mounted on
# free% = Available / total, rounded (same as btop; df Capacity rounds used% up).
free_pct="$(/bin/df -k "$mount_point" | /usr/bin/awk 'NR==2 && $2 > 0 { printf "%d", $4 * 100 / $2 + 0.5 }')"
if ! echo "$free_pct" | grep -Eq '^[0-9]+$'; then
    sketchybar --set disk_free label="err"
    exit 0
fi

if [ "$free_pct" -lt 0 ]; then free_pct=0; fi
if [ "$free_pct" -gt 100 ]; then free_pct=100; fi

sketchybar --set disk_free label="${free_pct}%"
