#!/bin/bash
# init/20_apt.sh — bootstrap APT-based distros: Debian, Ubuntu, Kali, e derivadas
# (Mint, Pop!_OS, Zorin, elementary). Substitui 20_linux_apt.sh + 20_ubuntu_apt.sh,
# arquivados em archive/legacy/.
#
# Estilo: declarativo via arrays (apt_keys, apt_source_files, apt_packages,
# deb_installed, deb_sources). PPAs e third-party repos via add_ppa(). Sem
# prompts interativos por categoria (a versão antiga tinha ~20 read -n 1
# bloqueando automação).

is_debian || return 1

# =============================================================================
# Sudoers — opt-in via prompt curto (permite "sudo apt" sem senha)
# =============================================================================
sudoers_old="/etc/sudoers.d/sudoers-sierra"
[[ -e "$sudoers_old" ]] && sudo rm "$sudoers_old"

sudoers_file="sudoers-dotfiles"
sudoers_src="$DOTFILES/conf/linux/$sudoers_file"
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ -e "$sudoers_src" && ( ! -e "$sudoers_dest" || "$sudoers_dest" -ot "$sudoers_src" ) ]]; then
  cat <<EOF
O sudoers pode ser atualizado pra permitir "sudo apt-get" sem senha.
Verifique com "sudo -k apt-get": se não pedir senha, funcionou.

DICA: tenha um shell root aberto em outra janela antes de aceitar.
EOF
  read -N 1 -t "${prompt_delay:-10}" -p "Update sudoers? [y/N] " update_sudoers
  echo
  if [[ "$update_sudoers" =~ [Yy] ]]; then
    e_header "Updating sudoers"
    visudo -cf "$sudoers_src" && \
      sudo cp "$sudoers_src" "$sudoers_dest" && \
      sudo chmod 0440 "$sudoers_dest" && \
      echo "Arquivo $sudoers_dest atualizado."
  else
    echo "Pulando."
  fi
fi

# =============================================================================
# Declarações
# =============================================================================
apt_keys=()
apt_source_files=()
apt_source_texts=()
apt_packages=()
deb_installed=()
deb_sources=()

installers_path="$DOTFILES/caches/installers"

# Ubuntu codename — só usado em PPAs/sources Ubuntu-specific
release_name=""
if is_ubuntu; then
  release_name="$(lsb_release -cs 2>/dev/null)"
fi

function add_ppa() {
  apt_source_texts+=("$1")
  IFS=':/' eval 'local parts=($1)'
  apt_source_files+=("${parts[1]}-ubuntu-${parts[2]}-$release_name")
}

# =============================================================================
# Pacotes universais (todo APT-family)
# =============================================================================
apt_packages+=(
  # Core dev / build
  build-essential
  ca-certificates
  apt-transport-https
  curl
  wget
  git-core
  mercurial
  vim

  # Asdf/build deps (Ruby, Python, PHP source builds)
  autoconf
  bison
  re2c
  libssl-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev
  libgdbm-dev zlib1g-dev
  libxml2-dev libgd-dev libpq-dev libcurl4-openssl-dev libonig-dev
  libmcrypt-dev libzip-dev
  libmagickwand-dev libmagickcore-dev

  # Network / SSH
  ansible
  awscli
  nmap
  ssh
  openssh-server
  telnet
  network-manager

  # Search / find
  silversearcher-ag
  tree

  # Sysadmin
  htop
  mlocate

  # Misc utilities
  imagemagick
  id3tool
  jq
  postgresql
  groff
  dialog

  # Docker
  docker.io
  docker-compose

  # Python (system base — pra tools que precisam, pipx é via 30_python_pip.sh)
  python3-pip

  # File converts / minify
  pdftk
  unoconv
  ufraw
  jpegoptim
  cabextract

  # Secure delete
  secure-delete

  # Diversão
  cmatrix
  cowsay
  sl
)

# =============================================================================
# Ubuntu-only (PPAs, versões mais novas)
# =============================================================================
if is_ubuntu; then
  apt_packages+=(thefuck)

  # neovim — versão mais nova via PPA
  add_ppa ppa:neovim-ppa/stable
  apt_packages+=(neovim)

  # tmux — versão mais nova
  add_ppa ppa:hnakamur/tmux

  # tmux-xpanes
  add_ppa ppa:greymd/tmux-xpanes
  apt_packages+=(tmux-xpanes)
fi

# =============================================================================
# Ubuntu desktop — GUI apps + third-party repos + .debs
# =============================================================================
if is_ubuntu_desktop; then
  apt_packages+=(vim-gnome handbrake-cli handbrake)

  # Theme + fonts + GUI utils
  add_ppa ppa:fossfreedom/arc-gtk-theme-daily
  apt_packages+=(arc-theme)

  add_ppa ppa:simon-cadman/niftyrepo
  apt_packages+=(cupscloudprint)

  add_ppa ppa:laurent-boulard/fonts
  apt_packages+=(fonts-iosevka)

  add_ppa ppa:danielrichter2007/grub-customizer
  apt_packages+=(grub-customizer)

  # VSCode
  apt_keys+=(https://tagplus5.github.io/vscode-ppa/ubuntu/gpg.key)
  apt_source_files+=(vscode.list)
  apt_source_texts+=("deb https://tagplus5.github.io/vscode-ppa/ubuntu ./")
  apt_packages+=(code code-insiders)

  # Google Chrome
  apt_keys+=(https://dl-ssl.google.com/linux/linux_signing_key.pub)
  apt_source_files+=(google-chrome)
  apt_source_texts+=("deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main")
  apt_packages+=(google-chrome-stable)

  # Charles Proxy
  apt_keys+=(https://www.charlesproxy.com/packages/apt/PublicKey)
  apt_source_files+=(charles)
  apt_source_texts+=("deb https://www.charlesproxy.com/packages/apt/ charles-proxy3 main")
  apt_packages+=(charles-proxy)

  # Spotify
  apt_keys+=(https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg)
  apt_source_files+=(spotify)
  apt_source_texts+=("deb http://repository.spotify.com stable non-free")
  apt_packages+=(spotify-client)

  # VirtualBox
  apt_keys+=(https://www.virtualbox.org/download/oracle_vbox_2016.asc)
  apt_source_files+=(virtualbox)
  apt_source_texts+=("deb http://download.virtualbox.org/virtualbox/debian $release_name contrib")
  apt_packages+=(virtualbox)

  # Skype
  apt_keys+=(https://repo.skype.com/data/SKYPE-GPG-KEY)
  apt_source_files+=(skype-stable)
  apt_source_texts+=("deb https://repo.skype.com/deb stable main")
  apt_packages+=(skypeforlinux)

  # OpenJDK 21 LTS
  apt_packages+=(openjdk-21-jdk)

  # Silentcast (screen recorder) + deps
  apt_packages+=(
    ffmpeg x11-xserver-utils xdotool wmctrl
    python3-gi python3-cairo xdg-utils yad
    silentcast
  )

  # Misc desktop apps + libs
  apt_packages+=(
    adb fastboot
    chromium-browser
    fonts-mplus
    gnome-tweak-tool
    k4dirstat
    rofi
    network-manager-openconnect
    network-manager-openconnect-gnome
    shutter
    unity-tweak-tool
    vlc
    xclip
    zenmap
    gimp
    meld
    thunderbird
    youtube-dl
    gedit gedit-plugins gedit-developer-plugins
    rxvt-unicode
    translate-shell
    texlive-binaries
    cups smbclient foomatic-db
    apparmor
    gocr
    apt-file apt-utils apt-listchanges dconf
    gnome-control-center gnome-online-accounts
  )

  # Vagrant via HashiCorp APT
  apt_keys+=(https://apt.releases.hashicorp.com/gpg)
  apt_source_files+=(hashicorp)
  apt_source_texts+=("deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $release_name main")
  apt_packages+=(vagrant)

  # .deb diretos
  deb_installed+=(/usr/bin/gitkraken)
  deb_sources+=(https://release.gitkraken.com/linux/gitkraken-amd64.deb)

  apt_packages+=(libqt5concurrent5)
  deb_installed+=(/usr/bin/notes)
  deb_sources+=("https://github.com/nuttyartist/notes/releases/download/v1.0.0/notes_1.0.0_amd64-$release_name.deb")

  apt_packages+=(python3-gi python3-gpg)
  deb_installed+=(/usr/bin/dropbox)
  deb_sources+=("https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2024.01.22_amd64.deb")

  deb_installed+=(/usr/share/fonts/truetype/msttcorefonts)
  deb_sources+=(deb_source_msttcorefonts)
  function deb_source_msttcorefonts() {
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    echo http://ftp.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb
  }

  deb_installed+=(/usr/bin/slack)
  deb_sources+=(https://downloads.slack-edge.com/releases/linux/4.41.105/prod/x64/slack-desktop-4.41.105-amd64.deb)

  deb_installed+=(/usr/bin/discord)
  deb_sources+=("https://discordapp.com/api/download?platform=linux&format=deb")

  apt_packages+=(python3-apt)
  deb_installed+=(/usr/bin/steam)
  deb_sources+=(deb_source_steam)
  function deb_source_steam() {
    local steam_root steam_file
    steam_root=http://repo.steampowered.com/steam/pool/steam/s/steam/
    steam_file="$(wget -q -O- "$steam_root?C=M;O=D" | sed -En '/steam-launcher/{s/.*href="([^"]+)".*/\1/;p;q;}')"
    echo "$steam_root$steam_file"
  }
fi

# =============================================================================
# Debian/Kali-only (sem PPAs Ubuntu)
# =============================================================================
if is_debianOS || is_kali; then
  apt_packages+=(
    ssh-askpass-gnome
    ssh-askpass
  )
fi

# =============================================================================
# EXECUÇÃO
# =============================================================================

# Add APT keys (deduplicado via cache)
keys_cache="$DOTFILES/caches/init/apt_keys"
mkdir -p "$(dirname "$keys_cache")"
touch "$keys_cache"
IFS=$'\n' GLOBIGNORE='*' command eval 'setdiff_cur=($(<$keys_cache))'
setdiff_new=("${apt_keys[@]}"); setdiff; apt_keys=("${setdiff_out[@]}")
unset setdiff_new setdiff_cur setdiff_out

if (( ${#apt_keys[@]} > 0 )); then
  e_header "Adding APT keys (${#apt_keys[@]})"
  for key in "${apt_keys[@]}"; do
    e_arrow "$key"
    if [[ "$key" =~ -- ]]; then
      sudo apt-key adv $key
    else
      wget -qO- "$key" | sudo apt-key add -
    fi && echo "$key" >> "$keys_cache"
  done
fi

# Add APT sources (deduplicado via arquivo .list já existente)
function __temp() { [[ ! -e /etc/apt/sources.list.d/$1.list ]]; }
source_i=($(array_filter_i apt_source_files __temp))

if (( ${#source_i[@]} > 0 )); then
  e_header "Adding APT sources (${#source_i[@]})"
  for i in "${source_i[@]}"; do
    source_file="${apt_source_files[i]}"
    source_text="${apt_source_texts[i]}"
    if [[ "$source_text" =~ ppa: ]]; then
      e_arrow "$source_text"
      sudo add-apt-repository -y "$source_text"
    else
      e_arrow "$source_file"
      sudo sh -c "echo '$source_text' > /etc/apt/sources.list.d/$source_file.list"
    fi
  done
fi

# Update APT
e_header "Updating APT"
sudo apt-get -qq update

# Upgrade — dist-upgrade no primeiro init (via bin/dotfiles), upgrade depois
e_header "Upgrading APT"
if is_dotfiles_bin; then
  sudo apt-get -qy upgrade
else
  sudo apt-get -qy dist-upgrade
fi

# Install pacotes (deduplicado via dpkg --get-selections)
installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

if (( ${#apt_packages[@]} > 0 )); then
  e_header "Installing APT packages (${#apt_packages[@]})"
  for package in "${apt_packages[@]}"; do
    e_arrow "$package"
    [[ "$(type -t "preinstall_$package")" == function ]] && "preinstall_$package"
    sudo apt-get -qq install "$package" && \
      [[ "$(type -t "postinstall_$package")" == function ]] && "postinstall_$package"
  done
fi

# Install .debs (deduplicado por arquivo já presente)
function __temp() { [[ ! -e "$1" ]]; }
deb_installed_i=($(array_filter_i deb_installed __temp))

if (( ${#deb_installed_i[@]} > 0 )); then
  mkdir -p "$installers_path"
  e_header "Installing .debs (${#deb_installed_i[@]})"
  for i in "${deb_installed_i[@]}"; do
    e_arrow "${deb_installed[i]}"
    deb="${deb_sources[i]}"
    [[ "$(type -t "$deb")" == function ]] && deb="$($deb)"
    installer_file="$installers_path/$(echo "$deb" | sed 's#.*/##')"
    wget -O "$installer_file" "$deb"
    sudo dpkg -i "$installer_file"
  done
fi

# Helper pra instalar bin via zip
function install_from_zip() {
  local name=$1 url=$2 bins b zip tmp
  shift 2
  bins=("$@")
  [[ "${#bins[@]}" == 0 ]] && bins=("$name")
  if ! command -v "$name" >/dev/null 2>&1; then
    mkdir -p "$installers_path"
    e_header "Installing $name"
    zip="$installers_path/$(echo "$url" | sed 's#.*/##')"
    wget -O "$zip" "$url"
    tmp="$(mktemp -d)"
    unzip "$zip" -d "$tmp"
    for b in "${bins[@]}"; do
      sudo cp "$tmp/$b" "/usr/local/bin/$(basename "$b")"
    done
    rm -rf "$tmp"
  fi
}

# Git Extras do vendor (se ainda existir; vendor/rbenv será removido em commit separado)
if [[ ! "$(pinpoint git-extras)" && -d "$DOTFILES/vendor/git-extras" ]]; then
  e_header "Installing Git Extras (do vendor/)"
  (cd "$DOTFILES/vendor/git-extras" && sudo make install)
fi

# Bins extras via zip
install_from_zip ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'
install_from_zip terraform 'https://releases.hashicorp.com/terraform/0.9.2/terraform_0.9.2_linux_amd64.zip'
