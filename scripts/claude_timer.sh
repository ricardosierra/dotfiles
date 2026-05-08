#!/bin/sh
# Claude usage timer — 5-hour countdown + usage % for tmux status bar.
# State files:
#   ${XDG_RUNTIME_DIR:-/tmp}/claude_start  — Unix timestamp of session start
#   ${XDG_RUNTIME_DIR:-/tmp}/claude_usage  — usage % (0-100), manual fallback

RUNTIME="${XDG_RUNTIME_DIR:-/tmp}"
TIMER_FILE="${RUNTIME}/claude_start"
USAGE_FILE="${RUNTIME}/claude_usage"
TOTAL=18000  # 5 hours in seconds

# --- Timestamp ---
if [ -f "$TIMER_FILE" ]; then
    START=$(cat "$TIMER_FILE" 2>/dev/null)
    case "$START" in
        ''|*[!0-9]*) START="" ;;
    esac
fi

NOW=$(date +%s)

# Auto-reset stale timer: se o elapsed ultrapassou o total, recomeça do zero
if [ -n "$START" ]; then
    ELAPSED=$((NOW - START))
    if [ "$ELAPSED" -gt "$TOTAL" ]; then
        START=""
        rm -f "$TIMER_FILE"
    fi
fi

if [ -z "$START" ]; then
    START=$NOW
    printf '%s\n' "$START" > "$TIMER_FILE"
fi

ELAPSED=$((NOW - START))
REMAINING=$((TOTAL - ELAPSED))
[ "$REMAINING" -lt 0 ] && REMAINING=0

HH=$((REMAINING / 3600))
MM=$(( (REMAINING % 3600) / 60 ))

# --- Usage % ---
# Fonte 1: ccusage (dados reais do dashboard Claude)
PCT=""
if command -v ccusage >/dev/null 2>&1; then
    RAW=$(ccusage 2>/dev/null | grep -oE '[0-9]+(\.[0-9]+)?%' | head -1)
    PCT=$(printf '%s' "$RAW" | tr -d '%' | cut -d. -f1)
    case "$PCT" in
        ''|*[!0-9]*) PCT="" ;;
    esac
    if [ -n "$PCT" ] && { [ "$PCT" -gt 100 ] || [ "$PCT" -lt 0 ]; } 2>/dev/null; then
        PCT=""
    fi
fi

# Fonte 2: arquivo manual (populado via claude-set)
if [ -z "$PCT" ] && [ -f "$USAGE_FILE" ]; then
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
