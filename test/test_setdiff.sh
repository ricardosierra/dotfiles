#!/usr/bin/env bash
# Testes legados para setdiff — migrado para test/unit.bats
# Corrigido: assert espera (actual, expected), não (expected, função)
source "$DOTFILES/source/00_dotfiles.sh"

e_header "$(basename "$0" .sh)"

run_test() {
  local desc="$1" expected="$2"
  shift 2
  local actual
  actual=$("$@")
  assert "$actual" "$expected"
}

# Strings
desired=(a b c); installed=()
run_test "a b c - ()" "a b c" setdiff "${desired[*]}" "${installed[*]}"

desired=(a b c); installed=(a)
run_test "a b c - a" "b c" setdiff "${desired[*]}" "${installed[*]}"

desired=(a b c); installed=(b)
run_test "a b c - b" "a c" setdiff "${desired[*]}" "${installed[*]}"

desired=(a b c); installed=(c)
run_test "a b c - c" "a b" setdiff "${desired[*]}" "${installed[*]}"

desired=(a b c); installed=(a b)
run_test "a b c - a b" "c" setdiff "${desired[*]}" "${installed[*]}"

desired=(a b c); installed=(c a)
run_test "a b c - c a" "b" setdiff "${desired[*]}" "${installed[*]}"

desired=(a a-b); installed=(a)
run_test "a a-b - a" "a-b" setdiff "${desired[*]}" "${installed[*]}"

desired=(a a-b); installed=(a-b)
run_test "a a-b - a-b" "a" setdiff "${desired[*]}" "${installed[*]}"

desired=(a a-b c); installed=(a-b)
run_test "a a-b c - a-b" "a c" setdiff "${desired[*]}" "${installed[*]}"

desired=(a a-b); installed=(a-b a)
run_test "a a-b - a-b a" "" setdiff "${desired[*]}" "${installed[*]}"

desired=(a-b a); installed=(a-b a)
run_test "a-b a - a-b a" "" setdiff "${desired[*]}" "${installed[*]}"

# Arrays
e_header "setdiff array mode"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b c); setdiff_cur=(); setdiff
assert "3" "$(echo ${#setdiff_out[@]})"
assert "a" "${setdiff_out[0]}"
assert "b" "${setdiff_out[1]}"
assert "c" "${setdiff_out[2]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b c); setdiff_cur=(a); setdiff
assert "2" "$(echo ${#setdiff_out[@]})"
assert "b" "${setdiff_out[0]}"
assert "c" "${setdiff_out[1]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b c); setdiff_cur=(c a); setdiff
assert "1" "$(echo ${#setdiff_out[@]})"
assert "b" "${setdiff_out[0]}"
