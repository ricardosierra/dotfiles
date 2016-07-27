# Package management
if is_debian; then
  alias update="sudo apt-get -qq update && sudo apt-get upgrade"
  alias install="sudo apt-get install"
  alias remove="sudo apt-get remove"
  alias search="apt-cache search"
elif is_archlinux; then
  alias update="sudo pacman -qq update && sudo pacman upgrade"
  alias install="sudo pacman install"
  alias remove="sudo pacman remove"
  alias search="pacman -Q"
elif is_linux; then
  alias update="sudo yum -qq update && sudo yum upgrade"
  alias install="sudo yum install"
  alias remove="sudo yum remove"
  alias search="yum -C search"
fi

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

ipif() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
	curl ipinfo.io/"$1"
    else
	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
	curl ipinfo.io/${ipawk[1]}
    fi
    echo
}
