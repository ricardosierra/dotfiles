#!/bin/bash

# Linux-only stuff. Abort if not Linux.
is_linux || return 1

# If the old files isn't removed, the duplicate APT alias will break sudo!
sudoers_old="/etc/sudoers.d/sudoers-sierra"; [[ -e "$sudoers_old" ]] && sudo rm "$sudoers_old"

# Installing this sudoers file makes life easier.
sudoers_file="sudoers-dotfiles"
sudoers_src=$DOTFILES/conf/linux/$sudoers_file
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ ! -e "$sudoers_dest" || "$sudoers_dest" -ot "$sudoers_src" ]]; then
  cat <<EOF
The sudoers file can be updated to allow "sudo apt-get" and "sudo yum" to be executed
without asking for a password. You can verify that this worked correctly by
running "sudo -k apt-get"or "sudo -k yum". If it doesn't ask for a password, and the output
looks normal, it worked.

THIS SHOULD ONLY BE ATTEMPTED IF YOU ARE LOGGED IN AS ROOT IN ANOTHER SHELL.

This will be skipped if "Y" isn't pressed within the next $prompt_delay seconds.
EOF
  read -N 1 -t $prompt_delay -p "Update sudoers file? [y/N] " update_sudoers; echo
  if [[ "$update_sudoers" =~ [Yy] ]]; then
    e_header "Updating sudoers"
    visudo -cf "$sudoers_src" &&
    sudo cp "$sudoers_src" "$sudoers_dest" &&
    sudo chmod 0440 "$sudoers_dest" &&
    echo "File $sudoers_dest updated." ||
    echo "Error updating $sudoers_dest file."
  else
    echo "Skipping."
  fi
fi

# Update APT.
e_header "Updating APT"


if is_debian; then
  sudo apt-get -qq update
  sudo apt-get -qq dist-upgrade
elif is_archlinux; then
  sudo pacman -Syuu --noconfirm
else
  sudo yum -qq update
  sudo yum -qq dist-upgrade
fi

# Install APT packages.
packages=(
    # Impressora
    cups
    smbclient
    foomatic-db 

    # Libs e Pacotes
    apparmor
    apt-transport-https
    ansible
    autoconf # for c compile
    build-essential # for c compile
    ca-certificates
    cowsay
    gedit
    gedit-developer-plugins
    gedit-plugins
    git-core
    gocr
    id3tool
    imagemagick
    #libxml2-dev # todo not identify by dpkg
    #libssl-dev # todo not identify by dpkg
    meld
    mercurial
    network-manager
    network-manager-openvpn
    network-manager-openvpn-gnome
    zenmap
    rxvt-unicode
    silversearcher-ag
    sl
    ssh
    sudo
    telnet
    thunderbird
    texlive-binaries
    translate-shell
    tree
    xclip
    #xcompmgr #compiz, nao funciona no ubuntu
    secure-delete # command srm (replaces a file before removing thus to avoid any type of file recovery)
    vim
    vim-gnome
    virtualbox

    # Network
    hostess
    nmap

    # Asdf needs
    re2c
    libgd-dev libcurl4-openssl-dev libonig-dev libmcrypt-dev libzip-dev libpq-dev #others requeriments

    # php requeriments
    libmagickwand-dev libmagickcore-dev

    # Editors
    gimp

    # Support Shell Script
    dialog

    # IOT
    youtube-dl

    # Files Converts/Minify
    pdftk
    unoconv
    ufraw
    jpegoptim
)


# More APT packages
if is_debianOS || is_kali; then
  packages+=(
    silversearcher-ag
    ssh-askpass-gnome
    ssh-askpass
    openssh-server
  )
elif is_archlinux; then
  packages+=(
    the_silver_searcher
    openssh-askpass
    openssh
  )
#UBuntu
else
  packages+=(
    silversearcher-ag
    ssh-askpass
    openssh-server
  )
fi



# ═══════════════════════════════════════════════════════════════════════════
#  SELEÇÃO POR CATEGORIA  (s = instala tudo da categoria, N = pula)
# ═══════════════════════════════════════════════════════════════════════════

# ── SISTEMA ─────────────────────────────────────────────────────────────────
echo ""
e_header "SISTEMA — Utilitários, terminal e sistema de arquivos"
echo "  build-essential, linux-headers, p7zip-full, unrar, tmux, screen,"
echo "  sshfs, ntfs-3g, apt-file, apt-utils, ipcalc, fcrackzip..."
read -N 1 -t 30 -p "Instalar? [s/N] " ans; echo
if [[ "$ans" =~ [Ss] ]]; then
  packages+=(
    build-essential g++ linux-headers-$(uname -r)
    tofrodos xinetd unrar p7zip-full fcrackzip ipcalc sharutils ldap-utils cabextract
    tmux screen tn5250
    apt-file apt-utils apt-listchanges dconf
    sshfs ntfs-3g genisoimage
  )
fi

# ── REDE ────────────────────────────────────────────────────────────────────
echo ""
e_header "REDE — Serviços de rede, monitoração e VPN"
echo "  samba, nfs-kernel-server, ntop, sysstat, procinfo, vpnc..."
read -N 1 -t 30 -p "Instalar? [s/N] " ans; echo
if [[ "$ans" =~ [Ss] ]]; then
  packages+=(
    samba nfs-kernel-server cifs-utils
    ntop sysstat procinfo
    vpnc
  )
fi

# ── HACKING ─────────────────────────────────────────────────────────────────
echo ""
e_header "HACKING — Pentest, análise de rede e segurança ofensiva"
echo "  netcat-openbsd, socat, nmap, fping, hping3, wireshark,"
echo "  ettercap-graphical, tcpdump, john, medusa, hydra, aircrack-ng, nikto..."
read -N 1 -t 30 -p "Instalar? [s/N] " ans; echo
if [[ "$ans" =~ [Ss] ]]; then
  # Tunneling
  packages+=(netcat-openbsd socat vtun stunnel4)
  # Scanners ativos
  packages+=(fping hping3 traceroute tcptraceroute ike-scan nbtscan sslscan python3-scapy)
  # Scanners passivos
  packages+=(p0f)
  # Sniffing
  packages+=(wireshark ettercap-graphical tcpdump tcpflow ssldump dsniff etherape)
  # Cracking
  packages+=(john medusa hydra)
  # Wireless
  packages+=(aircrack-ng)
  # Criptografia
  packages+=(gpa seahorse)
  # Web
  packages+=(nikto)
  # Bibliotecas
  packages+=(libssl-dev libpcap-dev libnet-dns-perl libsnmp-perl libnet-ssleay-perl ncurses-dev)
  # Dependências visualização (Scapy, etc.)
  packages+=(graphviz gv sox)
fi

# ── DESKTOP ─────────────────────────────────────────────────────────────────
echo ""
e_header "DESKTOP — Multimídia, comunicação e aplicações gráficas"
echo "  mpg123, filezilla, pidgin, thunderbird, irssi, tor, wine..."
read -N 1 -t 30 -p "Instalar? [s/N] " ans; echo
if [[ "$ans" =~ [Ss] ]]; then
  packages+=(
    mpg123
    filezilla pidgin pidgin-otr irssi tor
    wine
  )
fi

# ── DESENVOLVIMENTO ──────────────────────────────────────────────────────────
echo ""
e_header "DESENVOLVIMENTO — Java e ferramentas"
echo "  openjdk-21-jdk, liferea..."
read -N 1 -t 30 -p "Instalar? [s/N] " ans; echo
if [[ "$ans" =~ [Ss] ]]; then
  packages+=(openjdk-21-jdk liferea)
fi






packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

if (( ${#packages[@]} > 0 )); then
  e_header "Installing APT packages: ${packages[*]}"
  for package in "${packages[@]}"; do
    if is_debian; then
      sudo apt -qq install "$package" -y
    elif is_archlinux; then
      sudo pacman -qq install "$package" -y
    else
      sudo yum -qq install "$package" -y
    fi
  done
fi

# Install Git Extras
if [[ ! "$(pinpoint git-extras)" ]]; then
  echo ""
  echo [+] "Deseja instalar o Git Extras ? y/n" ;
  read -n 1 digx
  if [ $digx = "y" ]; then
    e_header "Installing Git Extras"
    (
      cd $DOTFILES/vendor/git-extras &&
      sudo make install
    )
  fi
fi

# Install Google-Chrome
if [[ ! "$(pinpoint google-chrome)" ]]; then
  echo ""
  echo [+] "Deseja instalar o Google Chrome? y/n" ;
  read -n 1 digx
  if [ $digx = "y" ]; then
    e_header "Installing Google-Chrome"
    (
      wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
      sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
      if is_debian; then
        sudo apt-get -qq update ; sudo apt-get -qq install google-chrome-stable -y
      elif is_archlinux; then
        sudo pacman -qq update ; sudo pacman -qq install google-chrome-stable -y
      else
        sudo yum -qq update ; sudo yum -qq install google-chrome-stable -y
      fi
    )
  fi
fi


echo ""
echo [+] "Deseja remover serviços desnecessarios do boot? y/n" ;
echo '.: exim4, tor, ntop, p0f, pads, isakmpd, nessusd, cups, samba, nis, nfs-common :.'
read -n 1 digx
if [ $digx = "y" ]
then
    update-rc.d -f exim4 remove
    update-rc.d -f tor remove
    update-rc.d -f ntop remove
    update-rc.d -f p0f remove
    update-rc.d -f pads remove
    update-rc.d -f isakmpd remove
    update-rc.d -f nessusd remove
    update-rc.d -f cups remove
    update-rc.d -f samba remove
    update-rc.d -f nis remove
    update-rc.d -f nfs-common remove
fi

# ssh
ssh-add /home/${USER}/.ssh/id_rsa
