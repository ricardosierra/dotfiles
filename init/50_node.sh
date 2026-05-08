#!/bin/bash
# Node.js via nave/volta — só executa se não foi instalado pelo 60_languages.sh

# Se node já existe (asdf, volta, ou nvm), não instala de novo
[[ "$(command -v node)" ]] && return 0

# Load nave- and npm-related functions.
source $DOTFILES/source/50_node.sh init

# Install latest stable Node.js, set as default, install global npm modules.
nave_install stable
# Install volta if necessary
if [[ ! "$VOLTA_HOME" ]]; then
  curl https://get.volta.sh | bash -s -- --skip-setup
  export VOLTA_HOME=~/.volta
  grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"
  volta install node
  volta install yarn
  volta install tsc
fi
