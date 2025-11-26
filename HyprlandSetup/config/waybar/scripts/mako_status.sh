#!/usr/bin/env bash

# mako_status.sh - simple mako indicator for Waybar
# shows bell icon or DND bell-slash

export PATH="/usr/bin:/bin:/usr/local/bin:$PATH"

MAKOCTL=$(command -v makoctl || true)

# fallback if makoctl is missing
if [ -z "$MAKOCTL" ]; then
  echo "󰂞"
  exit 0
fi

# check DND mode
if $MAKOCTL mode 2>/dev/null | grep -q "do-not-disturb"; then
  echo "󰂛"
else
  echo "󰂞"
fi
