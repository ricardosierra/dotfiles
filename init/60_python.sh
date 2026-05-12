#!/bin/bash
# Install Python (via asdf) + ferramentas CLI de dev (via pipx).
# Antes: sudo pip install fabric/pylint/grip — global, polui o sistema.
# Hoje: pipx isola cada ferramenta em seu próprio venv.

is_linux || is_osx || return 1

asdf plugin-add python 2>/dev/null || true
asdf install python latest

# Garantir pipx (idempotente — 30_python_pip.sh já cuida disso, mas re-checagem aqui não custa)
if ! command -v pipx >/dev/null 2>&1; then
  e_header "Installing pipx"
  if is_osx; then
    brew install pipx
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y pipx
  fi
  pipx ensurepath >/dev/null
fi

# Ferramentas CLI de dev Python.
# Note: nome do pacote nem sempre é igual ao binário (fabric → fab).
declare_pkg=(
  "fabric:fab"         # task runner remoto
  "pylint:pylint"      # linter
  "grip:grip"          # preview de README .md como GitHub
)

for entry in "${declare_pkg[@]}"; do
  pkg="${entry%%:*}"
  bin="${entry##*:}"
  if [[ ! "$(pinpoint "$bin")" ]]; then
    e_header "Installing $pkg via pipx"
    pipx install "$pkg"
  fi
done
