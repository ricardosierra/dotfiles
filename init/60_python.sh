#!/bin/bash

is_linux || is_osx || return 1

asdf plugin-add python
asdf install python latest

# Install Fabric
if [[ ! "$(type -P fab)" ]]; then
  e_header "Installing Fabric"
  (
    sudo pip install fabric
  )
fi

if [[ ! "$(type -P pylint)" ]]; then
  e_header "Installing Pylint"
  (
    sudo pip install pylint
  )
fi

if [[ ! "$(type -P grip)" ]]; then
  e_header "Installing grip"
  (
    sudo pip install grip
  )
fi
