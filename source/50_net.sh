# =============================================================================
# Rede — IP, DNS e monitoramento de tráfego HTTP
# =============================================================================

# IP externo via DNS do OpenDNS — mais rápido que curl pra sites externos
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"

# whois com servidor unificado (funciona melhor pra diferentes TLDs)
alias whois="whois -h whois-servers.net"

# limpa o cache de DNS local (macOS)
alias flush="dscacheutil -flushcache"

# monitora tráfego HTTP na interface en1 em tempo real
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# pingtest: faz ping num host e fala "ping" em voz alta a cada resposta bem-sucedida
# usa `say` no macOS ou `spd-say` no Linux
# uso: pingtest [host]  (padrão: 8.8.8.8)
function pingtest() {
  local c
  for c in say spd-say; do [[ "$(which $c)" ]] && break; done
  ping ${1:-8.8.8.8} | perl -pe '/bytes from/ && `'$c' ping`'
}
