#!/usr/bin/env bats
# Testes para funções de detecção de OS (bin/dotfiles)

setup() {
  export DOTFILES="$BATS_TEST_DIRNAME/.."
  source "$DOTFILES/bin/dotfiles" source || true

  # Arquivos temporários para simular /etc/issue e /etc/os-release
  FAKE_ISSUE=$(mktemp)
  FAKE_OSRELEASE=$(mktemp)

  # Redefine as funções para usar os arquivos temporários em vez dos reais
  is_ubuntu() {
    [[ "$(cat "$FAKE_ISSUE" 2>/dev/null)" =~ Ubuntu ]] && return 0
    local _id _id_like
    _id=$(. "$FAKE_OSRELEASE" 2>/dev/null && echo "$ID")
    _id_like=$(. "$FAKE_OSRELEASE" 2>/dev/null && echo "$ID_LIKE")
    [[ "$_id" =~ ^(ubuntu|linuxmint|zorin|pop|elementary)$ ]] && return 0
    [[ "$_id_like" =~ ubuntu ]] && return 0
    return 1
  }
  is_debianOS() {
    [[ "$(cat "$FAKE_ISSUE" 2>/dev/null)" =~ Debian ]] && return 0
    [[ "$(. "$FAKE_OSRELEASE" 2>/dev/null && echo "$ID")" == "debian" ]] || return 1
  }
  is_kali() {
    [[ "$(cat "$FAKE_ISSUE" 2>/dev/null)" =~ Kali ]] && return 0
    [[ "$(. "$FAKE_OSRELEASE" 2>/dev/null && echo "$ID")" == "kali" ]] || return 1
  }
  is_fedora() {
    [[ "$(cat "$FAKE_ISSUE" 2>/dev/null)" =~ Fedora ]] && return 0
    [[ "$(. "$FAKE_OSRELEASE" 2>/dev/null && echo "$ID")" == "fedora" ]] || return 1
  }
  is_archlinux() {
    [[ "$(cat "$FAKE_ISSUE" 2>/dev/null)" =~ Arch ]] && return 0
    [[ "$(. "$FAKE_OSRELEASE" 2>/dev/null && echo "$ID")" == "arch" ]] || return 1
  }
}

teardown() {
  rm -f "$FAKE_ISSUE" "$FAKE_OSRELEASE"
}

# Helper: escreve /etc/issue simulado
write_issue() { printf '%s\n' "$1" > "$FAKE_ISSUE"; }

# Helper: escreve /etc/os-release simulado
write_osrelease() { printf '%s\n' "$@" > "$FAKE_OSRELEASE"; }

# =============================================================================
# is_ubuntu — via /etc/issue
# =============================================================================

@test "is_ubuntu: /etc/issue contém 'Ubuntu' → true" {
  write_issue "Ubuntu 22.04.3 LTS \\n \\l"
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: /etc/issue vazio e sem os-release → false" {
  write_issue ""
  write_osrelease "ID=unknown"
  run is_ubuntu
  [ "$status" -ne 0 ]
}

# =============================================================================
# is_ubuntu — via /etc/os-release (distros derivadas)
# =============================================================================

@test "is_ubuntu: ID=ubuntu no os-release → true" {
  write_issue ""
  write_osrelease 'ID=ubuntu' 'ID_LIKE='
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: ID=linuxmint → true (derivada Ubuntu)" {
  write_issue "Linux Mint 21.3 Virginia"
  write_osrelease 'ID=linuxmint' 'ID_LIKE=ubuntu'
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: ID=pop → true (Pop!_OS)" {
  write_issue "Pop!_OS 22.04 LTS"
  write_osrelease 'ID=pop' 'ID_LIKE=ubuntu'
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: ID=zorin → true (Zorin OS)" {
  write_issue "Zorin OS 17"
  write_osrelease 'ID=zorin' 'ID_LIKE=ubuntu'
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: ID=elementary → true (elementary OS)" {
  write_issue "elementary OS 7.1 Horus"
  write_osrelease 'ID=elementary' 'ID_LIKE=ubuntu'
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: ID_LIKE=ubuntu genérico → true" {
  write_issue "Some Ubuntu Derivative"
  write_osrelease 'ID=myubuntudistro' 'ID_LIKE=ubuntu'
  run is_ubuntu
  [ "$status" -eq 0 ]
}

@test "is_ubuntu: ID=fedora → false" {
  write_issue "Fedora Linux 39"
  write_osrelease 'ID=fedora' 'ID_LIKE='
  run is_ubuntu
  [ "$status" -ne 0 ]
}

@test "is_ubuntu: ID=debian (sem issue Ubuntu) → false" {
  write_issue "Debian GNU/Linux 12 bookworm"
  write_osrelease 'ID=debian' 'ID_LIKE='
  run is_ubuntu
  [ "$status" -ne 0 ]
}

# =============================================================================
# is_debianOS
# =============================================================================

@test "is_debianOS: /etc/issue contém 'Debian' → true" {
  write_issue "Debian GNU/Linux 12 \\n \\l"
  run is_debianOS
  [ "$status" -eq 0 ]
}

@test "is_debianOS: ID=debian no os-release → true" {
  write_issue ""
  write_osrelease 'ID=debian'
  run is_debianOS
  [ "$status" -eq 0 ]
}

@test "is_debianOS: ID=ubuntu → false (ubuntu não é debianOS)" {
  write_issue ""
  write_osrelease 'ID=ubuntu'
  run is_debianOS
  [ "$status" -ne 0 ]
}

# =============================================================================
# is_kali
# =============================================================================

@test "is_kali: /etc/issue contém 'Kali' → true" {
  write_issue "Kali GNU/Linux Rolling"
  run is_kali
  [ "$status" -eq 0 ]
}

@test "is_kali: ID=kali no os-release → true" {
  write_issue ""
  write_osrelease 'ID=kali'
  run is_kali
  [ "$status" -eq 0 ]
}

@test "is_kali: ID=ubuntu → false" {
  write_issue ""
  write_osrelease 'ID=ubuntu'
  run is_kali
  [ "$status" -ne 0 ]
}

# =============================================================================
# is_fedora
# =============================================================================

@test "is_fedora: /etc/issue contém 'Fedora' → true" {
  write_issue "Fedora Linux 40"
  run is_fedora
  [ "$status" -eq 0 ]
}

@test "is_fedora: ID=fedora no os-release → true" {
  write_issue ""
  write_osrelease 'ID=fedora'
  run is_fedora
  [ "$status" -eq 0 ]
}

# =============================================================================
# is_osx — sem mock, testa no ambiente real
# =============================================================================

@test "is_osx: retorna true no macOS" {
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    run is_osx
    [ "$status" -eq 0 ]
  else
    skip "não está em macOS"
  fi
}

@test "is_osx: OSTYPE linux retorna false" {
  OSTYPE=linux-gnu run is_osx
  [ "$status" -ne 0 ]
}

# =============================================================================
# is_archlinux
# =============================================================================

@test "is_archlinux: /etc/issue contém 'Arch' → true" {
  write_issue "Arch Linux"
  run is_archlinux
  [ "$status" -eq 0 ]
}

@test "is_archlinux: ID=arch no os-release → true" {
  write_issue ""
  write_osrelease 'ID=arch'
  run is_archlinux
  [ "$status" -eq 0 ]
}

@test "is_archlinux: ID=ubuntu → false" {
  write_issue ""
  write_osrelease 'ID=ubuntu'
  run is_archlinux
  [ "$status" -ne 0 ]
}
