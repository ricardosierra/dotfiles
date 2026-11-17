#!/usr/bin/env bash
# Caça funções shell que sobrescrevem comandos do sistema.
# Shadowing legítimo (helpers como ga, gc) não aparece aqui — só os nomes críticos.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
grep -nE '^(function )?(git|ssh|scp|sftp|sudo|curl|sed|find|ls|cat|grep|rm|mv|cp|tar)\s*\(\)' \
  source/*.sh bin/dotfiles 2>/dev/null || true
