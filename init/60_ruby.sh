#!/bin/bash
# init/60_ruby.sh — instala rbenv (cross-platform) + Ruby 3.3.0 + bundler.
# Antes: sudo apt install rbenv (só funcionava em Debian/Ubuntu).
# Hoje: brew em macOS, apt em Debian/Ubuntu, instruções pro resto.

if ! command -v rbenv >/dev/null 2>&1; then
  if is_osx; then
    command -v brew >/dev/null 2>&1 && brew install rbenv ruby-build
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y rbenv ruby-build
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y rbenv ruby-build
  else
    e_error "rbenv não está instalado e não soube instalar automaticamente."
    e_error "Instale manualmente: https://github.com/rbenv/rbenv#installation"
    return 1
  fi
fi

# Initialize rbenv
# shellcheck disable=SC1091
source "$DOTFILES/source/50_ruby.sh"

# Install Ruby
if command -v rbenv >/dev/null 2>&1; then
  versions=(3.3.0)

  rubies=($(setdiff "${versions[*]}" "$(rbenv whence ruby 2>/dev/null)"))
  if (( ${#rubies[@]} > 0 )); then
    e_header "Installing Ruby versions: ${rubies[*]}"
    for r in "${rubies[@]}"; do
      rbenv install "$r"
      [[ "$r" == "${versions[0]}" ]] && rbenv global "$r"
    done
  fi
fi

# Install Bundler
gem install bundler
