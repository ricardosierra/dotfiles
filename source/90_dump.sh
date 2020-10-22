
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


download-website(){
	local website=$1
	wget --limit-rate=200k --mirror --adjust-extension --recursive --page-requisites --html-extension --convert-links -E -e robots=off -U mozilla --random-wait --no-parent $website
}
