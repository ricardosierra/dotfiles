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

git() {
  check-ssh-add
  /usr/bin/git $@
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
