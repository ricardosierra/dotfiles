#!/bin/bash

# Backups, swaps and undos are stored here.
mkdir -p $DOTFILES/caches/vim

# Download Vim plugins.
if [[ "$(pinpoint vim)" ]]; then
  vim +PlugUpgrade +PlugUpdate +qall
fi
