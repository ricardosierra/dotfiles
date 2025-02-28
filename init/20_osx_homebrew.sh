#!/bin/bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Install Homebrew.
if ! command -v brew >/dev/null 2>&1; then
  e_header "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> /Users/sierra/.bash_profile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/sierra/.bash_profile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Exit if, for some reason, Homebrew is not installed.
command -v brew >/dev/null 2>&1 || { e_error "Homebrew não está instalado. Abortei."; exit 1; }

e_header "Updating Homebrew"
brew doctor
brew update

# Functions used in subsequent init scripts.

# Tap Homebrew kegs.
function brew_tap_kegs() {
  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
  if (( ${#kegs[@]} > 0 )); then
    e_header "Tapping Homebrew kegs: ${kegs[*]}"
    for keg in "${kegs[@]}"; do
      brew tap $keg
    done
  fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
  recipes=($(setdiff "${recipes[*]}" "$(brew list)"))
  if (( ${#recipes[@]} > 0 )); then
    e_header "Installing Homebrew recipes: ${recipes[*]}"
    for recipe in "${recipes[@]}"; do
      brew install $recipe
    done
  fi
}
