# source/50_ruby.sh — inicializa rbenv (se disponível) ou rvm como fallback.
# shellcheck shell=bash
#
# Antes: tinha fallback pra $DOTFILES/vendor/rbenv/bin caso nenhum rbenv
# estivesse no PATH. Hoje: vendor/rbenv removido — install via brew/apt/asdf.

export PATH

# Initialize rbenv se disponível no PATH (via brew/apt/asdf-shim)
if command -v rbenv >/dev/null 2>&1 && ! type -t _rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# RVM como alternativa (system-wide ou user-local)
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/.rvm/scripts/rvm"
elif [[ -e /etc/profile.d/rvm.sh ]]; then
  # shellcheck disable=SC1091
  source /etc/profile.d/rvm.sh
fi
