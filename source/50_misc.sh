# Case-insensitive globbing (used in pathname expansion)
# globbing sem diferenciar maiúsculo/minúsculo — útil no completion
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# atualiza LINES e COLUMNS se a janela do terminal for redimensionada
shopt -s checkwinsize

# grep sempre colorido
alias grep='grep --color=auto'

# =============================================================================
# Timer do Claude (5 horas de janela de uso)
# =============================================================================

# claude-reset: zera o timer e o percentual de uso
# útil quando o Claude reinicia a janela de 5 horas
alias claude-reset='rm -f /tmp/claude_start /tmp/claude_usage && echo "Claude timer reset."'

# claude-set: sincroniza o timer com os valores reais do dashboard do Claude
# uso: claude-set 3h29m 86%
alias claude-set='~/.dotfiles/scripts/claude_set.sh'

# =============================================================================
# Utilitários de terminal
# =============================================================================

# Prevent less from clearing the screen while still showing colors.
# mantém o conteúdo visível após sair do less (sem limpar a tela)
export LESS=-XR

# titlebar: muda o título da barra do terminal
# uso: titlebar "meu projeto"
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# =============================================================================
# SSH auto-completion
# =============================================================================
# completa hosts SSH a partir do known_hosts (sem IPs, só nomes)
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi

# desabilita as vacas do Ansible (anunciam as mensagens de output)
export ANSIBLE_NOCOWS=1

# "fuck": corrige o último comando errado automaticamente
# ex: `git psuh` → `fuck` → executa `git push`
if [[ "$(which thefuck)" ]]; then
  eval "$(thefuck --alias)"
fi

# =============================================================================
# loop / loopc — repete um comando em intervalo fixo
# =============================================================================
# loop: repete um comando a cada N segundos (padrão: 1)
# loopc: igual, mas aceita múltiplos comandos com ponto-e-vírgula
#
# Exemplos:
#   loop 5 echo "oi"           — imprime "oi" a cada 5s
#   loopc 5 'echo foo; echo bar'  — roda dois comandos a cada 5s
function loopc() { loop "$@"; }
function loop() {
  local caller=$(caller 0 | awk '{print $2}')
  local delay=1
  if [[ $1 =~ ^[0-9]*(\.[0-9]+)?$ ]]; then
    delay=$1
    shift
  fi
  while true; do
    if [[ "$caller" == "loopc" ]]; then
      bash -c "$@"   # modo loopc: executa como string de shell
    else
      "$@"           # modo loop: executa como comando direto
    fi
    sleep $delay
  done
}
