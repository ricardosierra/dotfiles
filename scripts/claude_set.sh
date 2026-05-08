#!/bin/sh
# Sync Claude timer to values from the Claude dashboard.
# Usage: claude-set <time> [pct%]
#   claude-set 3h29m 86%
#   claude-set 45m 92%
#   claude-set 3h29m          (time only, keeps existing %)

RUNTIME="${XDG_RUNTIME_DIR:-/tmp}"
TIMER_FILE="${RUNTIME}/claude_start"
USAGE_FILE="${RUNTIME}/claude_usage"

input="$1"
pct_arg="$2"

if [ -z "$input" ]; then
    echo "Usage: claude-set <time> [pct%]  (e.g. claude-set 3h29m 86%)"
    exit 1
fi

hours=0
minutes=0

if echo "$input" | grep -qE '^[0-9]+h[0-9]+m$'; then
    hours=$(echo "$input" | sed 's/h.*//')
    minutes=$(echo "$input" | sed 's/.*h//;s/m//')
elif echo "$input" | grep -qE '^[0-9]+h$'; then
    hours=$(echo "$input" | sed 's/h//')
elif echo "$input" | grep -qE '^[0-9]+m$'; then
    minutes=$(echo "$input" | sed 's/m//')
else
    echo "Invalid time format. Use e.g. 3h29m or 45m"
    exit 1
fi

remaining=$(( hours * 3600 + minutes * 60 ))
fake_start=$(( $(date +%s) - (18000 - remaining) ))
printf '%s\n' "$fake_start" > "$TIMER_FILE"

if [ -n "$pct_arg" ]; then
    pct=$(echo "$pct_arg" | sed 's/%//')
    printf '%s\n' "$pct" > "$USAGE_FILE"
    echo "Claude timer set: ${hours}h${minutes}m remaining, ${pct}% used."
else
    echo "Claude timer set: ${hours}h${minutes}m remaining."
fi
