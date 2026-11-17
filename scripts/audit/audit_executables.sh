#!/usr/bin/env bash
# Lista todos os arquivos com bit de execução fora de .git/, link/, vendor/, backups/.
# Útil pra revisar o que está no PATH default via 01_path.sh.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
find . -type f -perm -111 \
  -not -path './.git/*' \
  -not -path './link/*' \
  -not -path './vendor/*' \
  -not -path './backups/*' |
  sort
