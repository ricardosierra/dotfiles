#!/usr/bin/env bash
# Arquivos versionados > 500KB (candidatos a archive ou .gitignore).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
find . -type f -size +500k \
  -not -path './.git/*' \
  -not -path './link/*' \
  -not -path './vendor/*' \
  -not -path './backups/*' \
  -exec ls -lh {} + | sort -k5 -hr
