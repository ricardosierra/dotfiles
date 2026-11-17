#!/usr/bin/env bash
# Reporta saúde do $PATH do shell que rodar este script:
# - total de entries
# - duplicatas
# - diretórios listados mas inexistentes
set -euo pipefail
IFS=':' read -ra parts <<< "$PATH"
echo "Total entries: ${#parts[@]}"
echo "Unique:        $(printf '%s\n' "${parts[@]}" | sort -u | wc -l | tr -d ' ')"
echo
echo "Duplicates:"
printf '%s\n' "${parts[@]}" | sort | uniq -d | sed 's/^/  /'
echo
echo "Missing dirs:"
for p in "${parts[@]}"; do
  [[ -d "$p" ]] || echo "  $p"
done
