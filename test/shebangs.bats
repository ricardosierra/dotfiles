#!/usr/bin/env bats
# Verifica que scripts críticos têm shebang na linha 1

setup() {
  DOTFILES="$BATS_TEST_DIRNAME/.."
}

# Helper: head em 4 bytes do arquivo
_has_shebang() {
  local f="$1"
  local head
  head=$(head -c 4 "$f" 2>/dev/null)
  [[ "$head" == "#!"* ]]
}

@test "todos init/*.sh têm shebang na linha 1" {
  failures=""
  for f in "$DOTFILES"/init/*.sh; do
    [[ -f "$f" ]] || continue
    if ! _has_shebang "$f"; then
      failures+="$(basename "$f") "
    fi
  done
  if [[ -n "$failures" ]]; then
    echo "Sem shebang: $failures"
    return 1
  fi
}

@test "scripts/claude_*.sh têm shebang na linha 1" {
  failures=""
  for f in "$DOTFILES"/scripts/claude_*.sh; do
    [[ -f "$f" ]] || continue
    if ! _has_shebang "$f"; then
      failures+="$(basename "$f") "
    fi
  done
  if [[ -n "$failures" ]]; then
    echo "Sem shebang: $failures"
    return 1
  fi
}

@test "scripts/audit/*.sh têm shebang na linha 1" {
  failures=""
  for f in "$DOTFILES"/scripts/audit/*.sh; do
    [[ -f "$f" ]] || continue
    if ! _has_shebang "$f"; then
      failures+="$(basename "$f") "
    fi
  done
  if [[ -n "$failures" ]]; then
    echo "Sem shebang: $failures"
    return 1
  fi
}

@test "bin/dotfiles tem shebang na linha 1" {
  _has_shebang "$DOTFILES/bin/dotfiles"
}

@test "bin/dotfiles-install-hooks tem shebang na linha 1" {
  _has_shebang "$DOTFILES/bin/dotfiles-install-hooks"
}

@test "novos scripts da rodada de auditoria têm shebang" {
  failures=""
  for f in \
    "$DOTFILES/bin/system/port-killer" \
    "$DOTFILES/bin/system/du-by-extension" \
    "$DOTFILES/bin/network/wifi-strength" \
    "$DOTFILES/bin/files/dedupe" \
    "$DOTFILES/bin/pentest/ssl-check" \
    "$DOTFILES/bin/dev/git-cleanup" \
    "$DOTFILES/bin/text/wc-by-language"; do
    [[ -f "$f" ]] || continue
    if ! _has_shebang "$f"; then
      failures+="$(basename "$f") "
    fi
  done
  if [[ -n "$failures" ]]; then
    echo "Sem shebang: $failures"
    return 1
  fi
}
