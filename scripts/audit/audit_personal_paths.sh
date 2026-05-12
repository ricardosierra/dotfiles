#!/usr/bin/env bash
# Caça hardcode de paths pessoais e refs a ferramentas fósseis.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
grep -RIlnE '/home/sierra|/Users/sierra|/Applications/Sublime Text 2|nave|Pebble|CDRW|beef|BEEF' \
  --include='*.sh' \
  --exclude-dir='.git' \
  --exclude-dir='vendor' \
  --exclude-dir='link' \
  --exclude-dir='backups' \
  --exclude-dir='archive' \
  . 2>/dev/null || true
