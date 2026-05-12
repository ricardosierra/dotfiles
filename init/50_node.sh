#!/bin/bash
# Install Node via volta (gerenciador padrão do dotfiles).
# Antes: usava nave_install (gerenciador morto) + volta como fallback.
# Hoje: só volta.

# Install volta se necessário
if [[ ! -d "$HOME/.volta" ]]; then
  e_header "Installing volta"
  curl https://get.volta.sh | bash -s -- --skip-setup
fi

export VOLTA_HOME="$HOME/.volta"
grep --silent "$VOLTA_HOME/bin" <<< "$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"

# Tooling base
volta install node@lts
volta install yarn
volta install typescript
