paths=(
  # Sistem Bins
  /usr/sbin
  /usr/bin
  /usr/local/sbin
  /usr/local/bin
  /sbin
  /bin
  /usr/games
  /snap/bin
  # Opt Programs
  /opt/flutter/bin
  # COMPOSER
  $HOME/.config/composer/vendor/bin
  $HOME/.composer/vendor/bin
  # Add local binaries
  $HOME/bin
  $HOME/opt/local/bin
  $HOME/.local/bin
  # Add binaries into the path
  $DOTFILES/bin
  $DOTFILES/bin/dev
  $DOTFILES/bin/files
  $DOTFILES/bin/games
  $DOTFILES/bin/life
  $DOTFILES/bin/network
  $DOTFILES/bin/pentest
  $DOTFILES/bin/security
  $DOTFILES/bin/sed
  $DOTFILES/bin/text
  # Android
  $ANDROID_HOME
  $ANDROID_PLATFORM_TOOLS
  $HOME/Android/Sdk
  $ANDROID_SDK_ROOT/platform-tools
  $ANDROID_SDK_ROOT/tools
  # Go
  /usr/local/go/bin
  $GOPATH/bin
  /usr/share/bcc/tools
)

# Configure PATHS (Caso ja exista, remove e entao add denovo. Caso o path seja vazio nao add o : no final)
export PATH
for p in "${paths[@]}"; do
  if [[ -d "$p" ]] then
    if [[ -z "$PATH" ]] then
      PATH="$p"
    else
      PATH="$p:$(path_remove "$p")"
    fi
  fi
done
unset p paths

# For Windows
if is_windows; then
	PATH="/c/Ruby23/bin:$PATH"
fi
