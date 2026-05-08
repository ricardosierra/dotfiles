#!/bin/bash
# Instalação de linguagens de programação (PHP, Ruby, Node, Python, Go)

is_linux || is_osx || return 1

# ── 1. Você é programador? ──────────────────────────────────────────────────
echo ""
read -N 1 -t 30 -p "Você é programador/desenvolvedor? [s/N] " is_developer; echo
[[ "$is_developer" =~ [Ss] ]] || return 0

# ── 2. Gerenciador de versões ───────────────────────────────────────────────
echo ""
echo "Como deseja instalar as linguagens de programação?"
echo "  1) Via asdf  (recomendado — gerenciador de versões unificado)"
echo "  2) Nativo    (rbenv, volta, etc.)"
read -N 1 -t 30 -p "Escolha [1/2]: " lang_manager; echo

use_asdf=0
[[ "$lang_manager" == "1" ]] && use_asdf=1

if [[ "$use_asdf" == "1" ]]; then
  if [[ ! -f "$HOME/.asdf/asdf.sh" ]]; then
    e_header "Instalando asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
  fi
  source "$HOME/.asdf/asdf.sh"
fi

# ── 3. Seleção de linguagens ────────────────────────────────────────────────
menu_options=("php" "ruby" "node" "python" "golang")
menu_selects=("${menu_options[@]}")
prompt_menu "Selecione as linguagens para instalar (ENTER confirma):" $prompt_delay

# ── 4. Instalação ───────────────────────────────────────────────────────────
for lang in "${menu_selects[@]}"; do
  case "$lang" in

    # ── PHP ─────────────────────────────────────────────────────────────────
    php)
      e_header "Instalando PHP"
      if [[ "$use_asdf" == "1" ]]; then
        asdf plugin-add php https://github.com/asdf-community/asdf-php.git 2>/dev/null || true
        asdf install php latest
        asdf global php latest
        pecl install redis   2>/dev/null || true
        pecl install imagick 2>/dev/null || true
        pecl install xdebug  2>/dev/null || true
      else
        sudo apt-get -qq install -y php php-cli php-common php-curl php-json \
          php-mbstring php-xml php-zip php-redis php-imagick php-xdebug 2>/dev/null || true
      fi
      if [[ "$(command -v composer)" ]]; then
        e_arrow "Composer já instalado"
      else
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
      fi
      composer global require "codeception/codeception:*" 2>/dev/null || true
      composer global require "phpstan/phpstan:*"         2>/dev/null || true
      ;;

    # ── Ruby ─────────────────────────────────────────────────────────────────
    ruby)
      e_header "Instalando Ruby"
      if [[ "$use_asdf" == "1" ]]; then
        asdf plugin-add ruby 2>/dev/null || true
        asdf install ruby latest
        asdf global ruby latest
      else
        [[ "$(command -v rbenv)" ]] || sudo apt-get -qq install -y rbenv
        source "$DOTFILES/source/50_ruby.sh" 2>/dev/null || true
        rbenv install 3.3.0 2>/dev/null || true
        rbenv global 3.3.0
      fi
      gem install bundler
      ;;

    # ── Node.js ───────────────────────────────────────────────────────────────
    node)
      e_header "Instalando Node.js"
      if [[ "$use_asdf" == "1" ]]; then
        asdf plugin-add nodejs 2>/dev/null || true
        asdf install nodejs latest
        asdf global nodejs latest
        npm install -g yarn typescript
      else
        curl https://get.volta.sh | bash -s -- --skip-setup
        export VOLTA_HOME=~/.volta
        grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"
        volta install node yarn
      fi
      ;;

    # ── Python ────────────────────────────────────────────────────────────────
    python)
      e_header "Instalando Python"
      if [[ "$use_asdf" == "1" ]]; then
        asdf plugin-add python 2>/dev/null || true
        asdf install python latest
        asdf global python latest
      else
        sudo apt-get -qq install -y python3 python3-pip python3-venv
      fi
      pip install fabric pylint grip 2>/dev/null || pip3 install fabric pylint grip 2>/dev/null || true
      ;;

    # ── Go ────────────────────────────────────────────────────────────────────
    golang)
      e_header "Instalando Go"
      if [[ "$use_asdf" == "1" ]]; then
        asdf plugin-add golang 2>/dev/null || true
        asdf install golang latest
        asdf global golang latest
      else
        GO_VERSION=1.24.3
        [[ -d /usr/local/go ]] && sudo rm -rf /usr/local/go
        curl -sSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
        export PATH="$PATH:/usr/local/go/bin"
      fi
      ;;
  esac
done
