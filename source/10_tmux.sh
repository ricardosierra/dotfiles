# =============================================================================
# Tmux — gerenciamento de sessões
# =============================================================================

# tm: conecta numa sessão tmux existente ou cria uma nova
# se já estiver dentro do tmux, avisa e não faz nada
# também serve como "portão de entrada": sai do shell ao fechar o tmux
function tm() {
  local is_source=; [[ "$1" == "SOURCE" ]] && is_source=1 && shift
  local tmux_no_logout=~/.dotfiles/caches/tmux-no-logout
  if [[ ! "$TMUX" ]]; then
    # limpa arquivo de controle que pode ter ficado pra trás
    [[ -e $tmux_no_logout ]] && rm $tmux_no_logout
    # conecta a sessão existente ou cria uma nova
    tmux ls >/dev/null 2>&1 && tmux attach "$@" || tmux "$@"
    # se o arquivo de "não logout" não existir, sai do shell ao fechar tmux
    [[ -e $tmux_no_logout ]] && rm $tmux_no_logout || exit
  elif [[ ! "$is_source" ]]; then
    echo "Already in a tmux session!"
  fi
}

# auto-start tmux no login (desabilitado — descomente se quiser)
# if shopt -q login_shell && [[ ! "$TMUX_AUTO_STARTED" ]]; then
#   TMUX_AUTO_STARTED=1
#   tm SOURCE
# fi

# run_in_fresh_tmux_window: roda um comando numa janela tmux limpa
# se tiver só um painel, roda ali mesmo; se tiver mais, cria janela nova
function run_in_fresh_tmux_window() {
  local panes="$(tmux list-panes | wc -l)"
  if [[ "$panes" != 1 ]]; then
    tmux new-window "bash --rcfile <(echo '. ~/.bashrc; $*')"
  else
    "$@"
  fi
}

# qq: abre editor + shell em janela nova no layout main-vertical
# uso: qq [num-paineis] [diretorio] [...args-pro-editor]
#   qq            — 1 painel no diretório atual
#   qq 2          — 2 painéis
#   qq 2 ~/Dev    — 2 painéis em ~/Dev
function qq() {
  local panes=1; [[ "$1" =~ ^[0-9]+$ ]] && panes=$1 && shift
  local dir="$PWD"; [[ -d "$1" ]] && dir="$(cd "$1" && pwd)" && shift
  local win=$(tmux new-window -P -a -c "$dir" -n "$(basename "$dir")")
  n_times $panes tmux split-window -t $win -c "$dir"
  tmux select-layout -t $win main-vertical
  tmux select-pane -t $win
  tmux send-keys -t $win "$EDITOR $*" Enter
}

alias q2='qq 2'   # qq com 2 painéis
alias q3='qq 3'   # qq com 3 painéis

alias tls='tmux ls'   # lista as sessões tmux abertas
