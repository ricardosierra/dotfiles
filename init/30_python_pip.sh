#!/bin/bash
# Installs Python CLI tools via pipx (isolated per-tool venvs).
# Antes: sudo pip install — poluía o Python do sistema.
# Hoje: pipx pra ferramentas CLI; libs por projeto em venvs.

# Garantir pipx
if ! command -v pipx >/dev/null 2>&1; then
  e_header "Installing pipx"
  if is_osx; then
    brew install pipx
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y pipx
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y pipx
  else
    e_error "Não soube instalar pipx neste sistema. Instale manualmente: https://pipx.pypa.io/"
    return 1
  fi
  pipx ensurepath >/dev/null
fi

# Ferramentas CLI Python (libs como netifaces/psutil ficam por projeto em venv).
pipx_tools=(
  tmuxp                # gerenciador de sessões tmux
)

for tool in "${pipx_tools[@]}"; do
  if ! pipx list --short 2>/dev/null | awk '{print $1}' | grep -qx "$tool"; then
    e_header "Installing $tool via pipx"
    pipx install "$tool"
  fi
done
