#!/usr/bin/env bash
# Runner de testes do dotfiles
# Uso: ./test/run_tests.sh [--legacy] [--bats] [--shellcheck] [--all]
#
# Sem argumentos: roda tudo

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
export DOTFILES

PASS=0; FAIL=0; SKIP=0
FAILED_SUITES=()

# Cores
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
BOLD='\033[1m'; RESET='\033[0m'

log()    { printf '%b\n' "$*"; }
header() { printf '\n%b=== %s ===%b\n' "$BOLD" "$*" "$RESET"; }

run_bats() {
  local file="$1"
  header "bats: $(basename "$file")"
  if ! bats "$file"; then
    FAILED_SUITES+=("$(basename "$file")")
    FAIL=$((FAIL + 1))
  else
    PASS=$((PASS + 1))
  fi
}

run_legacy() {
  local file="$1"
  header "legacy: $(basename "$file")"
  if ! DOTFILES="$DOTFILES" bash "$file"; then
    FAILED_SUITES+=("$(basename "$file")")
    FAIL=$((FAIL + 1))
  else
    PASS=$((PASS + 1))
  fi
}

run_shellcheck() {
  header "shellcheck"
  if ! command -v shellcheck >/dev/null 2>&1; then
    log "${YELLOW}SKIP${RESET} shellcheck não encontrado (brew install shellcheck)"
    SKIP=$((SKIP + 1))
    return
  fi

  local errors=0
  local files
  files=$(find "$DOTFILES" \
    \( -path "*/vendor/*" -o -path "*/.oh-my-zsh/*" \
       -o -path "*/.tmux/plugins/*" -o -path "*/.rbenv/*" \
       -o -path "*/.vim/plugged/*" \
       -o -path "*/.git/*" \) -prune \
    -o -name "*.sh" -print | sort)

  # source/ files não têm shebang por design — checar como bash
  local sc_errors
  if ! sc_errors=$(printf '%s\n' "$files" | \
      xargs shellcheck --shell=bash --severity=error --format=gcc 2>&1); then
    log "${RED}FALHA${RESET} shellcheck encontrou erros:"
    printf '%s\n' "$sc_errors" | grep -v "^$" | head -30
    FAILED_SUITES+=("shellcheck")
    FAIL=$((FAIL + 1))
  else
    log "${GREEN}OK${RESET} shellcheck: nenhum erro de nível error"
    PASS=$((PASS + 1))
  fi
}

# Seleciona o que rodar
RUN_BATS=1; RUN_LEGACY=1; RUN_SHELLCHECK=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --bats)       RUN_LEGACY=0; RUN_SHELLCHECK=0 ;;
    --legacy)     RUN_BATS=0;   RUN_SHELLCHECK=0 ;;
    --shellcheck) RUN_BATS=0;   RUN_LEGACY=0     ;;
    --all)        RUN_BATS=1;   RUN_LEGACY=1;   RUN_SHELLCHECK=1 ;;
    *) log "Uso: $0 [--bats] [--legacy] [--shellcheck] [--all]"; exit 1 ;;
  esac
  shift
done

log "${BOLD}Dotfiles Test Runner${RESET}"
log "DOTFILES=$DOTFILES"

# --- bats ---
if [[ "$RUN_BATS" -eq 1 ]]; then
  if ! command -v bats >/dev/null 2>&1; then
    log "${YELLOW}SKIP${RESET} bats não encontrado (brew install bats-core)"
    SKIP=$((SKIP + 1))
  else
    for f in "$DOTFILES"/test/*.bats; do
      run_bats "$f"
    done
  fi
fi

# --- legacy ---
if [[ "$RUN_LEGACY" -eq 1 ]]; then
  for f in "$DOTFILES"/test/test_*.sh; do
    run_legacy "$f"
  done
fi

# --- shellcheck ---
if [[ "$RUN_SHELLCHECK" -eq 1 ]]; then
  run_shellcheck
fi

# --- Resumo ---
printf '\n%b' "$BOLD"
printf '%-20s %s\n' "Suites OK:"     "$PASS"
printf '%-20s %s\n' "Suites FALHA:"  "$FAIL"
printf '%-20s %s\n' "Skipped:"       "$SKIP"
printf '%b\n' "$RESET"

if [[ "${#FAILED_SUITES[@]}" -gt 0 ]]; then
  log "${RED}${BOLD}FALHOU:${RESET}"
  for s in "${FAILED_SUITES[@]}"; do
    log "  • $s"
  done
  exit 1
fi

log "${GREEN}${BOLD}Todos os testes passaram.${RESET}"
