#!/bin/bash

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
