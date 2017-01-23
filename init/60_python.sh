#!/bin/bash

# Install Fabric
if [[ ! "$(type -P fab)" ]]; then
  e_header "Installing Fabric"
  (
    sudo pip install fabric
  )
fi
