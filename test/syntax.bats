#!/usr/bin/env bats
# Verificação de sintaxe bash em arquivos relevantes do repo

DOTFILES_ROOT="$BATS_TEST_DIRNAME/.."

# Arquivos .sh fora de vendor/submodules
_shell_files() {
  find "$DOTFILES_ROOT" \
    \( -path "*/vendor/*" \
    -o -path "*/.oh-my-zsh/*" \
    -o -path "*/.tmux/plugins/*" \
    -o -path "*/.rbenv/*" \
    -o -path "*/.git/*" \) -prune \
    -o -name "*.sh" -print \
    | sort
}

@test "bash -n: todos os arquivos .sh passam na checagem de sintaxe" {
  local failed=0
  local errors=""
  while IFS= read -r f; do
    if ! bash -n "$f" 2>/tmp/syntax_err; then
      failed=$((failed + 1))
      errors+="  FALHA: ${f#$DOTFILES_ROOT/}\n    $(cat /tmp/syntax_err)\n"
    fi
  done < <(_shell_files)
  rm -f /tmp/syntax_err
  if [ "$failed" -gt 0 ]; then
    echo "Arquivos com erro de sintaxe: $failed"
    printf '%b' "$errors"
    return 1
  fi
}

@test "bash -n: bin/dotfiles passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/bin/dotfiles"
  [ "$status" -eq 0 ]
}

@test "bash -n: scripts/claude_timer.sh passa na checagem" {
  run bash -n "$DOTFILES_ROOT/scripts/claude_timer.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: scripts/claude_set.sh passa na checagem" {
  run bash -n "$DOTFILES_ROOT/scripts/claude_set.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: init/60_golang.sh passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/init/60_golang.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: init/60_ruby.sh passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/init/60_ruby.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: init/20_apt.sh passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/init/20_apt.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: source/30_connection.sh passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/source/30_connection.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: source/50_file.sh passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/source/50_file.sh"
  [ "$status" -eq 0 ]
}

@test "bash -n: source/50_node.sh passa na checagem de sintaxe" {
  run bash -n "$DOTFILES_ROOT/source/50_node.sh"
  [ "$status" -eq 0 ]
}
