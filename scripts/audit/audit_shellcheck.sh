#!/usr/bin/env bash
# Roda shellcheck (severity=warning) em todos os shell scripts versionados,
# excluindo vendor/ e link/. Pre-push hook usa severity=error; este aqui é o relatório completo.
# Portátil pra bash 3.2 (macOS default) — sem mapfile.
cd "$(git rev-parse --show-toplevel)" || exit 1
if ! command -v shellcheck >/dev/null 2>&1; then
  echo "shellcheck não está instalado. brew install shellcheck"
  exit 1
fi
git ls-files '*.sh' 'bin/dotfiles*' 'scripts/*' |
  grep -vE '^(vendor|link)/' |
  xargs shellcheck --severity=warning
