#!/usr/bin/env bash
# Testes legados para path_remove — migrado para test/unit.bats
# Corrigido: PATH substituído apenas no escopo de cada chamada, não globalmente
source "$DOTFILES/source/00_dotfiles.sh"

e_header "$(basename "$0" .sh)"

# Helper: chama path_remove com PATH temporário e compara resultado
check() {
  local test_path="$1" remove_args=() expected
  shift
  # último argumento é o expected
  while [[ $# -gt 1 ]]; do remove_args+=("$1"); shift; done
  expected="$1"
  local actual
  actual=$(PATH="$test_path" path_remove "${remove_args[@]}")
  assert "$actual" "$expected"
}

TEST1=/a/b:/a/b/c:/a/b:/a/b/d
check "$TEST1" /a           "$TEST1"
check "$TEST1" /a/b/c/d     "$TEST1"
check "$TEST1" /a/b         "/a/b/c:/a/b/d"
check "$TEST1" /a/b/c       "/a/b:/a/b:/a/b/d"
check "$TEST1" /a/b/d       "/a/b:/a/b/c:/a/b"

TEST2="/a/b:/a/b c/d:/a/b:/a/b c/e"
check "$TEST2" /a           "$TEST2"
check "$TEST2" /a/b/c/d     "$TEST2"
check "$TEST2" /a/b         "/a/b c/d:/a/b c/e"
check "$TEST2" "/a/b c/d"   "/a/b:/a/b:/a/b c/e"
check "$TEST2" "/a/b c/e"   "/a/b:/a/b c/d:/a/b"

TEST3=/a/b:/a/b/c:/x:/a/b/d:/y:/a/b/e:/z
check "$TEST3" /a/b/c /a/b/d /a/b/e  "/a/b:/x:/y:/z"
