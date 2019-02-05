export PATH
 
if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
  eval "$(rbenv init -)"
elif [[ -e /etc/profile.d/rvm.sh ]]; then
  # rvm init
  source /etc/profile.d/rvm.sh
else
  # rbenv init.
  PATH="$(path_remove $DOTFILES/vendor/rbenv/bin):$DOTFILES/vendor/rbenv/bin"

  if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
    eval "$(rbenv init -)"
  fi
fi

source /home/sierra/.rvm/scripts/rvm
