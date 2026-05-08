#!/bin/bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/cowboy/dotfiles#os-x-notes
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /Library/Developer/CommandLineTools
fi

# Install asdf (binary release, detecta arquitetura)
ASDF_VERSION="v0.16.4"
ASDF_ARCH="$(uname -m | sed 's/x86_64/amd64/;s/arm64/arm64/')"
ASDF_TARBALL="asdf-${ASDF_VERSION}-darwin-${ASDF_ARCH}.tar.gz"
mkdir -p ~/.bin
curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/${ASDF_TARBALL}" \
  -o "/tmp/${ASDF_TARBALL}"
tar -xzf "/tmp/${ASDF_TARBALL}" -C ~/.bin/
rm "/tmp/${ASDF_TARBALL}"
xattr -d com.apple.quarantine ~/.bin/asdf 2>/dev/null || true