#!/bin/sh

# RAM usage plugin.
# Matches btop's macOS formula: used% = (active + wired) * page_size / hw.memsize, rounded.

total="$(/usr/sbin/sysctl -n hw.memsize)"

used_pct="$(/usr/bin/vm_stat | /usr/bin/awk -v total="$total" '
  /page size of/          { ps = $8 }
  /^Pages active/         { gsub(/\./, "", $3); a = $3 }
  /^Pages wired down/     { gsub(/\./, "", $4); w = $4 }
  END { if (total > 0) printf "%d", ((a + w) * ps * 100 / total) + 0.5; else print 0 }
')"

sketchybar --set ram_usage label="${used_pct}%"
