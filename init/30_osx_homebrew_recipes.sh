#!/bin/bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
command -v brew >/dev/null 2>&1 || { e_error "Homebrew não está instalado. Abortei."; exit 1; }

# H Lista de fórmulas do Homebrew para instalar
recipes=(
  ansible
  awscli
  bash
  cmatrix
  coreutils
  cowsay
  git
  git-extras
  htop
  hub
  id3tool
  jq
  lesspipe
  man2html
  mercurial
  nmap
  postgresql
  powerline-go
  reattach-to-user-namespace
  sl
  smartmontools
  ssh-copy-id
  telnet
  terminal-notifier
  the_silver_searcher
  thefuck
  tmux
  tmux-xpanes
  tree
  wget
  # Dependencias do php
  re2c
  # Dependencia LInux
  ext4fuse
  coreutils
  gnu-sed gawk
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin


# Atualiza permissões do htop
if [[ -x "$binroot/htop" ]] && [[ "$(stat -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" ]]; then
  e_header "Atualizando permissões do htop..."
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# Configura o Bash do Homebrew como shell padrão
if [[ -x "$binroot/bash" ]] && ! grep -q "$binroot/bash" /etc/shells; then
  e_header "Adicionando $binroot/bash à lista de shells aceitáveis..."
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read /Users/$USER UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Tornando $binroot/bash o shell padrão..."
  sudo chsh -s "$binroot/bash" "$USER"
  e_arrow "Reinicie todos os terminais para aplicar as mudanças."
fi