#!/bin/sh
# Claude usage timer — 5-hour countdown + usage % for tmux status bar.
# State files:
#   /tmp/claude_start  — Unix timestamp of (fake) session start
#   /tmp/claude_usage  — session usage percentage (0-100), set manually

TIMER_FILE="/tmp/claude_start"
USAGE_FILE="/tmp/claude_usage"
TOTAL=18000  # 5 hours in seconds

# --- Timestamp ---
if [ -f "$TIMER_FILE" ]; then
    START=$(cat "$TIMER_FILE" 2>/dev/null)
    case "$START" in
        ''|*[!0-9]*) START="" ;;
    esac
fi

if [ -z "$START" ]; then
    START=$(date +%s)
    printf '%s\n' "$START" > "$TIMER_FILE"
fi

NOW=$(date +%s)
ELAPSED=$((NOW - START))
REMAINING=$((TOTAL - ELAPSED))
[ "$REMAINING" -lt 0 ] && REMAINING=0

HH=$((REMAINING / 3600))
MM=$(( (REMAINING % 3600) / 60 ))

# --- Usage % ---
PCT=""
if [ -f "$USAGE_FILE" ]; then
    PCT=$(cat "$USAGE_FILE" 2>/dev/null)
    case "$PCT" in
        ''|*[!0-9]*) PCT="" ;;
    esac
    if [ -n "$PCT" ] && { [ "$PCT" -lt 0 ] || [ "$PCT" -gt 100 ]; } 2>/dev/null; then
        PCT=""
    fi
fi

# --- Color (based on time remaining) ---
if [ "$REMAINING" -gt 7200 ]; then
    COLOR="green"
elif [ "$REMAINING" -gt 1800 ]; then
    COLOR="yellow"
else
    COLOR="red"
fi

# --- Output ---
if [ -n "$PCT" ]; then
    printf '#[fg=%s]%02dh%02dm %s%%%s' "$COLOR" "$HH" "$MM" "$PCT" '#[default]'
else
    printf '#[fg=%s]%02dh%02dm#[default]' "$COLOR" "$HH" "$MM"
fi
