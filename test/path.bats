#!/usr/bin/env bats
# Verifica saúde do $PATH após bootstrap do shell.
# Tests iniciam com PATH mínimo pra isolar do ambiente do dev.

setup() {
  DOTFILES="$BATS_TEST_DIRNAME/.."
  export DOTFILES
}

# Helper: source dotfiles em subshell com PATH mínimo + retorna o PATH final
_sourced_path() {
  bash -c "
    export DOTFILES='$DOTFILES'
    export PATH='/usr/bin:/bin'
    # shellcheck disable=SC1091
    source '$DOTFILES/bin/dotfiles' source 2>/dev/null
    # shellcheck disable=SC1091
    source '$DOTFILES/source/01_path.sh'
    echo \"\$PATH\"
  "
}

@test "PATH sem entradas duplicadas após source dos dotfiles" {
  local path
  path=$(_sourced_path)
  dups=$(echo "$path" | tr ':' '\n' | sort | uniq -d)
  if [[ -n "$dups" ]]; then
    echo "Entradas duplicadas no PATH:"
    echo "$dups"
    return 1
  fi
}

@test "PATH sem entradas vazias após source dos dotfiles" {
  local path
  path=$(_sourced_path)
  empties=$(echo "$path" | tr ':' '\n' | grep -c '^$' || true)
  [[ "$empties" -eq 0 ]]
}

@test "PATH sem diretórios inexistentes após source dos dotfiles" {
  local path
  path=$(_sourced_path)
  missing=""
  while IFS= read -r p; do
    [[ -n "$p" ]] || continue
    [[ -d "$p" ]] || missing+="$p "
  done <<< "$(echo "$path" | tr ':' '\n')"
  if [[ -n "$missing" ]]; then
    echo "Diretórios em PATH que não existem:"
    echo "$missing"
    return 1
  fi
}
