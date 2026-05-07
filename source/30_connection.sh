# =============================================================================
# SSH / Git — garante que a chave SSH está no agent antes de conectar
# =============================================================================

# check-ssh-add: adiciona a chave SSH se ela não estiver no agent ainda
# expira após 5 horas (mesmo intervalo do timer do Claude)
check-ssh-add() {
  # if [ "$DESKTOP_SESSION" == "" ] then  # comentado: dava erro de parser no zsh
    if [[ `ssh-add -l` != *id_?sa* ]] then
      ssh-add -t 5h   # adiciona com expiração de 5 horas
    fi
  # fi
}

# sobrescreve ssh/scp/sftp/git pra sempre checar o agent antes de conectar
# assim você nunca recebe "Permission denied (publickey)" por esquecimento
slogin() {
  check-ssh-add
  /usr/bin/slogin "$@"
}

ssh() {
  check-ssh-add
  /usr/bin/ssh "$@"
}

scp() {
  check-ssh-add
  /usr/bin/scp "$@"
}

sftp() {
  check-ssh-add
  /usr/bin/sftp "$@"
}

git() {
  check-ssh-add
  /usr/bin/git "$@"
}
