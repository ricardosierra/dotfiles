check-ssh-add() {
if [ "$DESKTOP_SESSION" == "" ]; then
  if [[ `ssh-add -l` != *id_?sa* ]]; then 
    ssh-add -t 5h  ## 5 hour ssh-agent expiration
  fi
fi
}

slogin() {
  check-ssh-add
  /usr/bin/slogin $@
}

ssh() {
  check-ssh-add
  /usr/bin/ssh $@
}

scp() {
  check-ssh-add
  /usr/bin/scp $@
}

sftp() {
  check-ssh-add
  /usr/bin/sftp $@
}

#git() {
#  check-ssh-add
#  /usr/bin/git $@
#}
