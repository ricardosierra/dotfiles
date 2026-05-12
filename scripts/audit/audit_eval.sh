#!/usr/bin/env bash
# Lista uso de eval. Filtra padrões legítimos (rbenv/asdf/direnv init,
# thefuck alias, brew shellenv) que precisam de eval por design.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
grep -nE '\beval\b' bin/dotfiles source/*.sh init/*.sh scripts/*.sh 2>/dev/null |
  grep -vE 'rbenv init|thefuck|asdf|brew shellenv|direnv hook' || true
