export PATH

# rbenv init.
PATH="$(path_remove $DOTFILES/vendor/rbenv/bin):$DOTFILES/vendor/rbenv/bin"
 
if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
  eval "$(rbenv init -)"
fi

source /home/sierra/.rvm/scripts/rvm

