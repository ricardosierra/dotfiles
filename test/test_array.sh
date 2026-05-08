#!/usr/bin/env bash
# Testes legados para funções de array — migrado para test/unit.bats
# Corrigido: IFS não deve ser empty ao capturar saída de array_map com process substitution
source "$DOTFILES/source/00_dotfiles.sh"

e_header "$(basename "$0" .sh)"

function test_assert() { assert "$actual" "$expected"; }

# Fixtures
empty=()
fixture1=(a b "" "c d" " e " "  'f'  " " \"g'h\" " i "")

# Captura saída preservando trailing newlines (sem IFS= que quebrava o for loop interno)
capture() {
  local tmpfile
  tmpfile=$(mktemp)
  "$@" > "$tmpfile"
  # Adiciona sentinela para preservar trailing newlines após $()
  actual=$(cat "$tmpfile"; printf x)
  actual="${actual%x}"
  rm -f "$tmpfile"
}

e_header array_map

capture array_map empty
expected=$''
test_assert

capture array_map fixture1
expected=$'a\nb\n\nc d\n e \n  \'f\'  \n \"g\'h\" \ni\n\n'
test_assert

function map() { echo "<$2:${1:-X}>"; }
capture array_map fixture1 map
expected=$'<0:a>\n<1:b>\n<2:X>\n<3:c d>\n<4: e >\n<5:  \'f\'  >\n<6: \"g\'h\" >\n<7:i>\n<8:X>\n'
test_assert

e_header array_print

capture array_print empty
expected=$''
test_assert

capture array_print fixture1
expected=$'0 <a>\n1 <b>\n2 <>\n3 <c d>\n4 < e >\n5 <  \'f\'  >\n6 < \"g\'h\" >\n7 <i>\n8 <>\n'
test_assert

e_header array_filter

capture array_filter empty
expected=$''
test_assert

capture array_filter fixture1
expected=$'a\nb\nc d\n e \n  \'f\'  \n \"g\'h\" \ni\n'
test_assert

e_header array_join

capture array_join empty ','
expected=$''
test_assert

capture array_join fixture1 ','
expected=$'a,b,,c d, e ,  \'f\'  , \"g\'h\" ,i,\n'
test_assert

e_header array_join_filter

capture array_join_filter empty ','
expected=$''
test_assert

capture array_join_filter fixture1 ','
expected=$'a,b,c d, e ,  \'f\'  , \"g\'h\" ,i\n'
test_assert
