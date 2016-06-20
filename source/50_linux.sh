# Ubuntu-only stuff. Abort if not Ubuntu.
is_linux || return 1

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
else
  alias update="sudo yum -qq update && sudo yum upgrade"
  alias install="sudo yum install"
  alias remove="sudo yum remove"
  alias search="yum -C search"
fi

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Switch between already-downloaded node versions.
function node_ver() {
  (
    ver="${1#v}"
    nodes=()
    if [[ ! -e "/usr/local/src/node-v$ver" ]]; then
      shopt -s extglob
      shopt -s nullglob
      cd "/usr/local/src"
      eval 'for n in node-v*+([0-9]).+([0-9]).+([0-9]); do nodes=("${nodes[@]}" "${n#node-}"); done'
      [[ "$1" ]] && echo "Node.js version \"$1\" not found."
      echo "Valid versions are: ${nodes[*]}"
      [[ "$(type -P node)" ]] && echo "Current version is: $(node --version)"
      exit 1
    fi
    cd "/usr/local/src/node-v$ver"
    sudo make install >/dev/null 2>&1 &&
    echo "Node.js $(node --version) installed." ||
    echo "Error, $(node --version) installed."
  )
}
