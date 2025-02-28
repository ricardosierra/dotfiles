# Package management
if is_osx; then
  alias update="brew -qq update && brew upgrade"
  alias install="brew install"
  alias remove="brew remove"
  alias search="brew search"
elif is_debian; then
  alias update="sudo apt -qq update && sudo apt upgrade"
  alias install="sudo apt install"
  alias remove="sudo apt remove"
  alias search="apt search"
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

alias e="exit"
