#!/usr/bin/env bats
# Testes unitarios: path_remove, setdiff, array_map/filter/join

setup() {
  export DOTFILES="$BATS_TEST_DIRNAME/.."
  source "$DOTFILES/bin/dotfiles" source || true
}

# =============================================================================
# path_remove
# =============================================================================

@test "path_remove: segmento ausente nao altera PATH" {
  result=$(PATH=/a/b:/a/b/c:/a/b/d path_remove /x)
  [ "$result" = "/a/b:/a/b/c:/a/b/d" ]
}

@test "path_remove: remove segmento do meio" {
  result=$(PATH=/a/b:/a/b/c:/a/b/d path_remove /a/b/c)
  [ "$result" = "/a/b:/a/b/d" ]
}

@test "path_remove: remove duplicatas" {
  result=$(PATH=/a/b:/a/b/c:/a/b:/a/b/d path_remove /a/b)
  [ "$result" = "/a/b/c:/a/b/d" ]
}

@test "path_remove: remove segmento do inicio" {
  result=$(PATH=/a/b:/a/b/c:/a/b/d path_remove /a/b)
  [ "$result" = "/a/b/c:/a/b/d" ]
}

@test "path_remove: remove segmento do fim" {
  result=$(PATH=/a/b:/a/b/c:/a/b/d path_remove /a/b/d)
  [ "$result" = "/a/b:/a/b/c" ]
}

@test "path_remove: remove multiplos segmentos em uma chamada" {
  result=$(PATH=/a/b:/a/b/c:/x:/a/b/d:/y path_remove /a/b/c /a/b/d)
  [ "$result" = "/a/b:/x:/y" ]
}

@test "path_remove: PATH vazio retorna vazio" {
  result=$(PATH= path_remove /a/b)
  [ "$result" = "" ]
}

@test "path_remove: segmento com espaco no nome" {
  result=$(PATH="/a/b:/a/b c/d:/a/b/d" path_remove "/a/b c/d")
  [ "$result" = "/a/b:/a/b/d" ]
}

# =============================================================================
# setdiff
# =============================================================================

@test "setdiff: desired maior que installed retorna diferenca" {
  result=$(setdiff "a b c" "a")
  [ "$result" = "b c" ]
}

@test "setdiff: desired igual a installed retorna vazio" {
  result=$(setdiff "a b c" "a b c")
  [ "$result" = "" ]
}

@test "setdiff: installed vazio retorna desired completo" {
  result=$(setdiff "a b c" "")
  [ "$result" = "a b c" ]
}

@test "setdiff: item com hifen nao confundido com prefixo" {
  result=$(setdiff "a a-b" "a")
  [ "$result" = "a-b" ]
}

@test "setdiff: remove multiplos itens" {
  result=$(setdiff "a b c d" "b d")
  [ "$result" = "a c" ]
}

@test "setdiff: modo array - desired vazio retorna setdiff_out vazio" {
  unset setdiff_new setdiff_cur setdiff_out
  setdiff_new=(); setdiff_cur=(a b c); setdiff || true
  [ "${#setdiff_out[@]}" -eq 0 ]
}

@test "setdiff: modo array - 3 elementos novos" {
  unset setdiff_new setdiff_cur setdiff_out
  setdiff_new=(a b c); setdiff_cur=(); setdiff || true
  [ "${#setdiff_out[@]}" -eq 3 ]
  [ "${setdiff_out[0]}" = "a" ]
  [ "${setdiff_out[1]}" = "b" ]
  [ "${setdiff_out[2]}" = "c" ]
}

@test "setdiff: modo array - remove item instalado" {
  unset setdiff_new setdiff_cur setdiff_out
  setdiff_new=(a b c); setdiff_cur=(a); setdiff || true
  [ "${#setdiff_out[@]}" -eq 2 ]
  [ "${setdiff_out[0]}" = "b" ]
  [ "${setdiff_out[1]}" = "c" ]
}

# =============================================================================
# array_map
# =============================================================================

@test "array_map: array vazio retorna vazio" {
  arr=()
  result=$(array_map arr) || true
  [ "$result" = "" ]
}

@test "array_map: imprime cada elemento em linha separada" {
  arr=(foo bar baz)
  result=$(array_map arr)
  [ "$result" = $'foo\nbar\nbaz' ]
}

@test "array_map: preserva espacos dentro de elementos" {
  arr=("hello world" "foo  bar")
  result=$(array_map arr)
  [ "$result" = $'hello world\nfoo  bar' ]
}

# =============================================================================
# array_filter
# =============================================================================

@test "array_filter: remove strings vazias" {
  arr=(a "" b "" c)
  result=$(array_filter arr)
  [ "$result" = $'a\nb\nc' ]
}

@test "array_filter: array todo vazio retorna vazio" {
  arr=("" "")
  result=$(array_filter arr) || true
  [ "$result" = "" ]
}

# =============================================================================
# array_join
# =============================================================================

@test "array_join: junta com virgula" {
  arr=(a b c)
  result=$(array_join arr ',')
  [ "$result" = "a,b,c" ]
}

@test "array_join: array vazio retorna vazio" {
  arr=()
  # array_join retorna exit 1 quando resultado vazio (comportamento esperado)
  result=$(array_join arr ',') || true
  [ "$result" = "" ]
}

@test "array_join_filter: remove vazios antes de juntar" {
  arr=(a "" b "" c)
  result=$(array_join_filter arr ',')
  [ "$result" = "a,b,c" ]
}
