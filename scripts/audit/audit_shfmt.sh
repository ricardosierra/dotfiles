#!/usr/bin/env bash
# Mostra diffs de formatação shfmt (2 espaços) em todos os shell scripts.
# Portátil pra bash 3.2 (macOS default) — sem mapfile.
cd "$(git rev-parse --show-toplevel)" || exit 1
if ! command -v shfmt >/dev/null 2>&1; then
  echo "shfmt não está instalado. brew install shfmt"
  exit 1
fi
git ls-files '*.sh' 'bin/dotfiles*' 'scripts/*' |
  grep -vE '^(vendor|link)/' |
  xargs shfmt -d -i 2
