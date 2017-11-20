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
  sudo pacman -qq update
  sudo pacman -qq dist-upgrade
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
    python
    python-pip
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



echo ""
echo [+] "Deseja instalar os componentes essenciais do sitema e utilitários (recomendado)? y/n" ;
echo '.: build-essential, linux-headers, sysvconfig, bum, tofrodos, xinetd, unrar, p7zip-full, fcrackzip, ipcalc, sharutils, xclip, ldap-utils, cabextract, g++, ssh :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    build-essential
    linux-headers-`uname -r`
    sysvconfig
    bum
    tofrodos
    xinetd
    unrar
    p7zip-full
    fcrackzip
    ipcalc
    sharutils
    xclip
    ldap-utils
    cabextract
    g++
    ssh
  )
fi


echo ""
echo [+] "Deseja instalar os servicos de rede? y/n" ;
echo '.: samba, nis, nfs, smbfs :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    samba
    nis
    nfs
    smbfs
  )
fi


echo ""
echo [+] "Deseja instalar os servicos de monitoracao? y/n" ;
echo '.: ntop, sysstat, procinfo :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    ntop
    sysstat
    procinfo
  )
fi


echo ""
echo [+] "Deseja instalar os gerenciadores de pacotes? y/n" ;
echo '.: apt-file, apt-utils, apt-listchanges, dconf :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    #apt-build
    #apt-dpkg-ref
    #apt-listbugs
    apt-file
    #apt-howto
    apt-utils
    apt-listchanges
    dconf
  )
fi


echo ""
echo [+] "Deseja instalar os emuladores de terminal? y/n" ;
echo '.: tmux tn5250, screen :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
	  tmux
    tn5250
    screen
  )
fi


echo ""
echo [+] "Deseja instalar as ferramentas de sistemas de arquivos? y/n" ;
echo '.: sshfs, ntfs-3g, ntfs-config, ntfsprogs, mkisofs :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    sshfs
    ntfs-3g
    ntfs-config
    ntfsprogs
    mkisofs
  )
fi


echo ""
echo [+] "Deseja instalar algumas configuracoes do Gnome? y/n" ;
echo '.: gconf, gnomebaker, nautilus-open-terminal :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    gconf
    gnomebaker
    nautilus-open-terminal
  )
fi


echo ""
echo [+] "Deseja instalar o ISAKPMD e VPNc? y/n" ;
echo '.: vpnc :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    isakmpd
    vpnc
  )
fi


echo ""
echo [+] "Deseja instalar os pacotes de Multimidia? y/n" ;
echo '.: amarok, xmms, xmms-skins, xmms-mp4, mpg123, totem-xine, ksnapshot, istanbul, recordmydesktop, gtk-recordmydesktop, xvidcap :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    amarok
    xmms
    xmms-skins
    xmms-mp4
    mpg123
    totem-xine
    ksnapshot
    istanbul
    recordmydesktop
    gtk-recordmydesktop
    xvidcap
  )
fi


echo ""
echo [+] "Deseja instalar o Netcat e ferramentas de Tunnelling? y/n" ;
echo '.: netcat, sbd, cryptcat, socat, vtun, stunnel :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    netcat
    sbd
    cryptcat
    socat
    vtun
    stunnel
  )
fi


echo ""
echo [+] "Deseja instalar Scanners? y/n" ;
echo '.: nmap, fping, hping2, hping3, scapy, snmp, traceroute, ike-scan, nbtscan, sslscan :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    nmap
    fping
    hping2
    hping3
    scapy
    snmp
    traceroute
    tcptraceroute
    ike-scan
    nbtscan
    sslscan
  )
fi


echo ""
echo [+] "Deseja instalar Scanners Passivos? y/n" ;
echo '.: p0f, pads :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    p0f
    pads
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas de sniffing? y/n" ;
echo '.: wireshark, ettercap, ettercap-gtk, tcpdump, tcpflow, ssldump, nemesis, dsniff, etherape :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    wireshark
    ettercap
    ettercap-gtk
    tcpdump
    tcpflow
    ssldump
    nemesis
    dsniff
    etherape
  )
fi


echo ""
echo [+] "Deseja instalar as bibliotecas (recomendado)? y/n" ;
echo '.: libssl, libssl-dev, libssh-2, python-pycurl, libnet-dns-perl, libsnmp-perl, libcrypt-ssleay-perl, libnet-ssleay-perl, ncurses-dev, libpcap-dev :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    libssl
    libssl-dev
    libssh-2
    python-pycurl
    libnet-dns-perl
    libsnmp-perl
    libcrypt-ssleay-perl
    libnet-ssleay-perl
    ncurses-dev
    libpcap-dev
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas de cracking? y/n" ;
echo '.: john, medusa, hydra :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    john
    medusa
    hydra
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas para Wireless? y/n" ;
echo '.: aircrack, aircrack-ng :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    aircrack
    aircrack-ng
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas de linha de comando para aplicacoes Web? y/n" ;
echo '.: wget, curl, nikto :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    wget
    curl
    nikto
  )
fi


echo ""
echo [+] "Deseja instalar linguagens de script? y/n" ;
echo '.: ruby, python, perl, perl-doc, gawk, vim-ruby, vim-python :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    ruby
    python
    perl
    perl-doc
    gawk
    vim-ruby
    vim-python
  )
fi


echo ""
echo [+] "Deseja instalar o Ruby Gems? y/n" ;
echo '.: gems, rubygems :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    gems
    rubygems
  )
fi


echo ""
echo [+] "Deseja instalar as dependencias do Metasploit? y/n" ;
echo '.: libopenssl-ruby, ruby-libglade2, libgtk2-ruby :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    libopenssl-ruby
    ruby-libglade2
    libgtk2-ruby
  )
fi


echo ""
echo [+] "Deseja instalar as dependencias do Scapy? y/n" ;
echo '.: graphviz, imagemagick, python-gnuplot, python-crypto, python-visual, python-pyx, acroread, gv, sox :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    graphviz
    imagemagick
    python-gnuplot
    python-crypto
    python-visual
    python-pyx
    acroread
    gv
    sox
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas para Documentacao? y/n" ;
echo '.: notecase, vim, liferea :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    notecase
    vim
    liferea
  )
fi


echo ""
echo [+] "Deseja instalar Utilitários para Browsers/Web? y/n" ;
echo '.: azerus, opera, filezilla, pidgin, pidgin-otr, thunderbird, lightning-extension, enigmail, irssi, silc, tor :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    azureus
    opera
    filezilla
    pidgin
    pidgin-otr
    thunderbird
    lightning-extension
    enigmail
    irssi
    silc
    tor
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas para Windows? y/n" ;
echo '.: wine, quicksynergy :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    wine
    quicksynergy
  )
fi


echo ""
echo [+] "Deseja instalar ferramentas de criptografia? y/n" ;
echo '.: dmsetup, password-gorilla, gpa, seahorse :.'
read digx
if [ $digx = "y" ]
then
  packages+=(
    dmsetup
    password-gorilla
    gpa
    seahorse
  )
fi




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
if [[ ! "$(type -P git-extras)" ]]; then
  echo ""
  echo [+] "Deseja instalar o Git Extras ? y/n" ;
  read digx
  if [ $digx = "y" ]; then
    e_header "Installing Git Extras"
    (
      cd $DOTFILES/vendor/git-extras &&
      sudo make install
    )
  fi
fi

# Install Google-Chrome
if [[ ! "$(type -P google-chrome)" ]]; then
  echo ""
  echo [+] "Deseja instalar o Google Chrome? y/n" ;
  read digx
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

# Install Google Hangout
if [[ ! "$(dpkg -l |grep google-talkplugin)" ]]; then
  echo ""
  echo [+] "Deseja instalar o Google Hangout? y/n" ;
  read digx
  if [ $digx = "y" ]; then
    e_header "Installing Google Hangout"
    (
      if is_debian; then
        wget https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb -O ~/Downloads/google-talkplugin.deb
        sudo dpkg -i ~/Downloads/google-talkplugin.deb
        rm ~/Downloads/google-talkplugin.deb
      else
        wget https://dl.google.com/linux/direct/google-talkplugin_current_x86_64.rpm -O ~/Downloads/google-talkplugin.rpm
        sudo dpkg -i ~/Downloads/google-talkplugin.rpm
        rm ~/Downloads/google-talkplugin.rpm
      fi
    )
  fi
fi

echo ""
echo [+] "Deseja instalar o Java? y/n" ;
echo '.: openjdk-7-jre, openjdk-7-jdk :.'
read digx
if [ $digx = "y" ]
then
    if is_debian; then
      sudo apt -qq install openjdk-7-jre -y
      sudo apt -qq install openjdk-7-jdk -y
    elif is_archlinux; then
      sudo pacman -qq install openjdk-7-jre -y
      sudo pacman -qq install openjdk-7-jdk -y
    else
      sudo yum -qq install openjdk-7-jre -y
      sudo yum -qq install openjdk-7-jdk -y
    fi
    java -version
fi


echo ""
echo [+] "Deseja remover serviços desnecessarios do boot? y/n" ;
echo '.: exim4, tor, ntop, p0f, pads, isakmpd, nessusd, cups, samba, nis, nfs-common :.'
read digx
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
