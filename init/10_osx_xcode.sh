#!/bin/bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/cowboy/dotfiles#os-x-notes
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /Library/Developer/CommandLineTools
fi

# Install asdf
curl -LO https://github.com/asdf-vm/asdf/releases/download/v0.16.4/asdf-v0.16.4-darwin-arm64.tar.gz
tar -xzf asdf-v0.16.4-darwin-arm64.tar.gz
xattr -d com.apple.quarantine ~/.bin/asdf