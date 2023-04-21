# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

if [ "$DOTFILES_DEBUG" = yes ]; then
  echo 'Loading zprofile...'
fi

# # Esse arquivo é chamado pelo zsh
# if [ -f "$HOME/.profile" ]; then
#     . "$HOME/.profile"
# fi
export PATH="/home/sierra/.local/share/solana/install/active_release/bin:$PATH"
