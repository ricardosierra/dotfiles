# Python 3.12+ (PEP 668): pip recusa instalação em sistema sem flag explícita.
# CLI tools → pipx (ambiente isolado, sem conflito com sistema)
# Libraries → pip3 com --break-system-packages

# pipx: instala se necessário
if ! command -v pipx &>/dev/null; then
  if command -v pip3 &>/dev/null; then
    pip3 install --break-system-packages pipx 2>/dev/null || sudo apt-get -qq install -y pipx
  else
    sudo apt-get -qq install -y pipx
  fi
fi

# CLI tools via pipx (cada um em ambiente isolado)
pipx_tools=(
  tmuxp
)

for tool in "${pipx_tools[@]}"; do
  if ! pipx list 2>/dev/null | grep -q "$tool"; then
    e_arrow "pipx install $tool"
    pipx install "$tool"
  fi
done

# Libraries Python via pip3 --break-system-packages
pip_packages=(
  netifaces
  psutil
)

if command -v pip3 &>/dev/null; then
  installed_pip_packages="$(pip3 list 2>/dev/null | awk '{print $1}')"
  pip_packages=($(setdiff "${pip_packages[*]}" "$installed_pip_packages"))

  if (( ${#pip_packages[@]} > 0 )); then
    e_header "Installing pip packages (${#pip_packages[@]})"
    for package in "${pip_packages[@]}"; do
      e_arrow "$package"
      pip3 install --break-system-packages "$package"
    done
  fi
fi
