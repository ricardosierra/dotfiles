#!/usr/bin/env bash
# Lista scripts em bin/, source/, init/, scripts/, test/ sem shebang.
# Útil pra detectar arquivos shell que vão rodar com o shell errado.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
find bin source init scripts test -type f -not -path '*/.*' -print0 2>/dev/null |
  xargs -0 -I{} sh -c '
    head=$(head -c 4 "$1" 2>/dev/null)
    case "$head" in
      "#!"*) ;;
      *) printf "%s\n" "$1" ;;
    esac
  ' _ {}
