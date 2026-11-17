#!/usr/bin/env bash
# Configura Git hooks globais anti-autoria forçada de IA (Cursor, Claude, Grok, Codex, Gemini, etc.)
# Idempotente e compatível com macOS, Linux e Windows (Git Bash/WSL/MSYS).

if ! declare -f e_header >/dev/null 2>&1; then
  e_header()  { echo -e "\n\033[1m$*\033[0m"; }
  e_success() { echo -e " \033[1;32m✔\033[0m  $*"; }
fi

e_header "Configurando Git hooks de proteção global"

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# 1. Garante que os diretórios necessários existem
mkdir -p "$HOME/.git_hooks"
mkdir -p "$HOME/.git_template/hooks"
mkdir -p "$HOME/.config/husky"

# 2. Copia arquivos para ~/.git_hooks caso não seja link ou esteja vazio (essencial no Windows)
if [ ! -f "$HOME/.git_hooks/commit-msg" ] && [ -d "$DOTFILES/link/.git_hooks" ]; then
  cp -f "$DOTFILES/link/.git_hooks/"* "$HOME/.git_hooks/" 2>/dev/null || true
fi

# 3. Permissões de execução nos hooks principais
chmod +x "$HOME/.git_hooks/"* 2>/dev/null || true
[ -d "$DOTFILES/link/.git_hooks" ] && chmod +x "$DOTFILES/link/.git_hooks/"* 2>/dev/null || true

# 4. Copia arquivos para ~/.git_template/hooks
if [ ! -f "$HOME/.git_template/hooks/commit-msg" ] && [ -d "$DOTFILES/link/.git_hooks" ]; then
  cp -f "$DOTFILES/link/.git_hooks/"* "$HOME/.git_template/hooks/" 2>/dev/null || true
fi
chmod +x "$HOME/.git_template/hooks/"* 2>/dev/null || true

# 5. Garante ~/.config/husky/init.sh
if [ ! -f "$HOME/.config/husky/init.sh" ] && [ -f "$DOTFILES/config/husky/init.sh" ]; then
  cp -f "$DOTFILES/config/husky/init.sh" "$HOME/.config/husky/init.sh" 2>/dev/null || true
fi
chmod +x "$HOME/.config/husky/init.sh" 2>/dev/null || true

# 6. Configura git globalmente
git config --global core.hooksPath "$HOME/.git_hooks"
git config --global init.templateDir "$HOME/.git_template"

e_success "Git hooks globais configurados em ~/.git_hooks (core.hooksPath e init.templateDir ativos)"
