check-ssh-add() {
if [ "$DESKTOP_SESSION" == "" ]; then
 if [[ `ssh-add -l` != *id_?sa* ]]; then 
   ssh-add -t 5h  ## 5 hour ssh-agent expiration
 fi
fi
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
  eval e/usr/bin/ssh ${QUOTE_ARGS}
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

youtube-dump() {
  if [ -e "$1" ] ; then
    OLDIFS=$IFS
    IFS=$'\n'
    for line in `< $1`; do
      newfile=`youtube-dl.py -o %\(title\)s.%\(ext\)s $line | grep '^\[download\]' | cut -d ' ' -f 3-`
      ffmpeg -b 192k -i $newfile ${newfile/flv/mp3}
      rm $newfile
    done
    IFS=$OLDIFS
  else
    echo "Arquivo não existe!"
  fi
}
