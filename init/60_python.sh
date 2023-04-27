#!/bin/bash

is_linux || is_osx || return 1

asdf plugin-add python
asdf install python latest

# Install Fabric
if [[ ! "$(pinpoint fab)" ]]; then
  e_header "Installing Fabric"
  (
    sudo pip install fabric
  )
fi

if [[ ! "$(pinpoint pylint)" ]]; then
  e_header "Installing Pylint"
  (
    sudo pip install pylint
  )
fi

if [[ ! "$(pinpoint grip)" ]]; then
  e_header "Installing grip"
  (
    sudo pip install grip
  )
fi
