check-ssh-add() {
  # if [ "$DESKTOP_SESSION" == "" ] then # @todo comentei pq tava dando erro de parser no zsh
    if [[ `ssh-add -l` != *id_?sa* ]] then 
      ssh-add -t 5h  ## 5 hour ssh-agent expiration
    fi
  # fi
}

slogin() {
  check-ssh-add
  QUOTE_ARGS=''
  for ARG in "$@"
  do
    QUOTE_ARGS="${QUOTE_ARGS} '${ARG}'"
  done
  eval /usr/bin/slogin ${QUOTE_ARGS}
}

ssh() {
  check-ssh-add
  QUOTE_ARGS=''
  for ARG in "$@"
  do
    QUOTE_ARGS="${QUOTE_ARGS} '${ARG}'"
  done
  eval /usr/bin/ssh ${QUOTE_ARGS}
}

scp() {
 check-ssh-add
 QUOTE_ARGS=''
 for ARG in "$@"
 do
   QUOTE_ARGS="${QUOTE_ARGS} '${ARG}'"
 done
 eval /usr/bin/scp ${QUOTE_ARGS}
}

sftp() {
 check-ssh-add
 QUOTE_ARGS=''
 for ARG in "$@"
 do
   QUOTE_ARGS="${QUOTE_ARGS} '${ARG}'"
 done
 eval /usr/bin/sftp ${QUOTE_ARGS}
}

git() {
 check-ssh-add
 QUOTE_ARGS=''
 for ARG in "$@"
 do
   QUOTE_ARGS="${QUOTE_ARGS} '${ARG}'"
 done
 eval /usr/bin/git ${QUOTE_ARGS}
}
