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
  # Helpers
  copyclip
  # Dependencias do php
  re2c
  gd
  freetype
  libzip
  # Dependencia LInux
  ext4fuse
  coreutils
  gnu-sed gawk
  # Ferramentas pra ler qualquer tipo de arquivo
  antiword           # .doc legado (Word 6/97/2000/2003)
  dcraw              # RAW de câmeras (CR2, NEF, ARW, etc.)
  exiftool           # metadados de qualquer arquivo
  fd                 # find moderno
  ffmpeg             # áudio/vídeo (qualquer container)
  file-formula       # `file` GNU mais novo que o do macOS
  imagemagick        # conversão/leitura de imagens (incl. HEIC, PSD)
  libarchive         # bsdtar — lê tar, ar, iso, xar, lha, cpio, etc.
  mediainfo          # metadados detalhados de mídia
  mupdf-tools        # mutool — PDF/EPUB/XPS/CBZ
  p7zip              # 7z, zip, rar (read), iso, dmg
  pandoc             # converte praticamente qualquer formato de documento
  poppler            # pdftotext/pdfimages/pdfinfo
  qpdf               # inspeção/manipulação de PDF
  ripgrep            # busca em árvore (rg)
  sevenzip           # 7-Zip 24+ oficial (sucessor do p7zip)
  shellcheck         # lint estático de shell scripts
  sleuthkit          # análise forense de filesystems (fsstat, fls, icat)
  tesseract          # OCR (extrai texto de imagem)
  testdisk           # photorec — recupera arquivos / inspeciona partições
  unar               # The Unarchiver CLI — RAR, 7z, StuffIt, ACE, etc.
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin


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