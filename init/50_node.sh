<<<<<<< HEAD
#!/bin/bash

# Load nave- and npm-related functions.
source $DOTFILES/source/50_node.sh init

# Install latest stable Node.js, set as default, install global npm modules.
nave_install stable
=======
# Install volta if necessary
if [[ ! "$VOLTA_HOME" ]]; then
  curl https://get.volta.sh | bash -s -- --skip-setup
  export VOLTA_HOME=~/.volta
  grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"
  volta install node
  volta install yarn
  volta install tsc
fi
>>>>>>> 09aa03cab27cdd2496df4a550b32a33af0f9f832
