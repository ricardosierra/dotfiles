# =============================================================================
# Sistema — gerenciamento de pacotes e utilitários gerais
# =============================================================================

# update/install/remove/search: comandos unificados que funcionam em qualquer OS
# o sistema detecta qual gerenciador de pacotes usar (brew, apt, pacman, yum)
if is_osx; then
  alias update="brew -qq update && brew upgrade"  # atualiza tudo no macOS
  alias install="brew install"
  alias remove="brew remove"
  alias search="brew search"
elif is_debian; then
  alias update="sudo apt -qq update && sudo apt upgrade"  # atualiza tudo no Debian/Ubuntu
  alias install="sudo apt install"
  alias remove="sudo apt remove"
  alias search="apt search"
elif is_archlinux; then
  alias update="sudo pacman -qq update && sudo pacman upgrade"
  alias install="sudo pacman install"
  alias remove="sudo pacman remove"
  alias search="pacman -Q"
elif is_linux; then
  alias update="sudo yum -qq update && sudo yum upgrade"  # fallback para yum (RHEL/CentOS)
  alias install="sudo yum install"
  alias remove="sudo yum remove"
  alias search="yum -C search"
fi

# habilita o lesspipe pra visualizar binários com less (ex: gzip, tar)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ipif: mostra informações geográficas de um IP ou domínio
# aceita IP diretamente ou resolve o hostname primeiro
# uso: ipif 8.8.8.8  ou  ipif google.com
ipif() {
    if [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
	curl ipinfo.io/"$1"
    else
	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
	curl ipinfo.io/${ipawk[1]}
    fi
    echo
}

alias e="exit"   # sai do shell rapidinho
