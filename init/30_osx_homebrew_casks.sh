#!/bin/bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
command -v brew >/dev/null 2>&1 || { e_error "Homebrew não está instalado. Abortei."; exit 1; }

# Ensure the cask kegs are installed.
kegs=(
  # homebrew/cask-drivers # Obsoleto
  # homebrew/cask-fonts   # Obsoleto
  # homebrew/cask-versions # Obsoleto
)
brew_tap_kegs

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  # Applications
  a-better-finder-rename
  alfred
  android-platform-tools
  bartender
  battle-net
  bettertouchtool
  betterzip
  caprine
  charles
  chromium
  chronosync
  controllermate
  datagrip
  docker
  dropbox
  fastscripts
  google-chrome
  firefox
  gimp
  gyazo
  hex-fiend
  iterm2
  karabiner-elements
  licecap
  macvim
  menumeters
  meld
  messenger-for-desktop
  microsoft-remote-desktop-beta
  midi-monitor
  moom
  ngrok
  numi
  omnidisksweeper
  postman
  reaper
  robo-3t
  scroll-reverser
  seil
  sharemouse
  skype
  slack
  sourcetree
  star-realms
  synology-assistant
  teamspeak-client
  teamviewer
  spotify
  steam
  the-unarchiver
  tower
  vagrant
  virtualbox
  visual-studio-code
  vlc
  xscreensaver
  zeplin
  # Desenvolvimento
  pidof
  # Quick Look plugins
  qlcolorcode
  qlmarkdown
  qlprettypatch
  qlstephen
  quicklook-csv
  quicklook-json
  quicknfo
  suspicious-package
  webpquicklook
  # Drivers
  sonos
  xbox360-controller-driver-unofficial
  # Fonts
  font-m-plus
  font-mplus-nerd-font
  font-mplus-nerd-font-mono
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew list --cask 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew install --cask $cask
  done
fi

# Work around colorPicker symlink issue.
# https://github.com/caskroom/homebrew-cask/issues/7004
cps=()
for f in ~/Library/ColorPickers/*.colorPicker; do
  [[ -L "$f" ]] && cps=("${cps[@]}" "$f")
done

if (( ${#cps[@]} > 0 )); then
  e_header "Fixing colorPicker symlinks"
  for f in "${cps[@]}"; do
    target="$(readlink "$f")"
    e_arrow "$(basename "$f")"
    rm "$f"
    cp -R "$target" ~/Library/ColorPickers/
  done
fi
