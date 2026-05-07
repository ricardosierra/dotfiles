#!/bin/bash

# =============================================================================
# Utilitários de sistema — calculadora, compressão, JSON, rede, certif SSL
# =============================================================================

# calc: calculadora de linha de comando com precisão de 10 casas decimais
# uso: calc "2 + 2"  ou  calc "3.14 * 2"
calc() {
	local result=""
	result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
	#						└─ default (when `--mathlib` is used) is 20

	if [[ "$result" == *.* ]]; then
		# melhora a exibição: remove zeros à direita e adiciona "0" antes do ponto
		printf "$result" |
		sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
			-e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
			-e 's/0*$//;s/\.$//'; # remove trailing zeros
	else
		printf "$result"
	fi
	printf "\n"
}

# gz: compara o tamanho original de um arquivo com o tamanho gzipado
# uso: gz arquivo.txt
gz() {
	local origsize=$(wc -c < "$1")
	local gzipsize=$(gzip -c "$1" | wc -c)
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
	printf "orig: %d bytes\n" "$origsize"
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# json: formata e colore JSON (aceita argumento ou pipe)
# uso: json '{"foo":42}'  ou  cat arquivo.json | json
json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	else # pipe
		python -mjson.tool | pygmentize -l javascript
	fi
}

# digga: roda dig e mostra só o que importa (todos os records de uma vez)
# uso: digga google.com
digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# mwiki: consulta o Wikipedia via DNS (retorna o resumo em texto)
# uso: mwiki bash  ou  mwiki linux kernel
mwiki() {
	dig +short txt "$*".wp.dg.cx
}

# escape: converte uma string em sequências \x{XX} de Unicode
# uso: escape "héllo"
escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	if [ -t 1 ]; then
		echo ""
	fi
}

# unidecode: decodifica sequências \x{ABCD} de volta pra texto
# uso: unidecode "\x{0041}"
unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	if [ -t 1 ]; then
		echo ""
	fi
}

# codepoint: mostra o code point Unicode de um caractere
# uso: codepoint é   → U+00E9
codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
	if [ -t 1 ]; then
		echo ""
	fi
}

# getcertnames: mostra todos os domínios (CN e SANs) de um certificado SSL
# uso: getcertnames google.com
getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified."
		return 1
	fi

	local domain="${1}"
	echo "Testing ${domain}…"
	echo ""

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" 2>&1)

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_header, no_serial, no_version, \
			no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
		echo "Common Name:"
		echo ""
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
		echo ""
		echo "Subject Alternative Name(s):"
		echo ""
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
		return 0
	else
		echo "ERROR: Certificate not found."
		return 1
	fi
}

# v: abre o vim no diretório atual ou num arquivo específico
# uso: v          → abre o diretório atual
#      v arquivo  → abre o arquivo
v() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}

# o: abre o explorador de arquivos (xdg-open no Linux)
# uso: o          → abre o diretório atual
#      o pasta/   → abre a pasta
o() {
	if [ $# -eq 0 ]; then
		xdg-open . > /dev/null 2>&1
	else
		xdg-open "$@" > /dev/null 2>&1
	fi
}

# tre: tree com arquivos ocultos, cores, ignorando .git, paginado
tre() {
	tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

# man: man page com cores bonitas usando LESS_TERMCAP
unalias man 2>/dev/null
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
        command man "$@"
}

# dbs: lista serviços do D-Bus (session ou system)
# uso: dbs           → lista sessão
#      dbs system    → lista serviços do sistema
dbs() {
	local t=$1
	if [[  -z "$t" ]]; then
		local t="session"
	fi

	dbus-send --$t --dest=org.freedesktop.DBus \
		--type=method_call --print-reply \
		/org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

# isup: checa se uma URL está respondendo com 200 OK
# manda notificação desktop com o resultado
# uso: isup https://meusite.com
isup() {
	local uri=$1

	if curl -s --head  --request GET "$uri" | grep "200 OK" > /dev/null ; then
		notify-send --urgency=critical "$uri is down"
	else
		notify-send --urgency=low "$uri is up"
	fi
}

# xname: pega o nome e classe de uma janela X11 pelo ID
# uso: xname <window-id>  (pegue o ID com xwininfo)
xname(){
	local window_id=$1

	if [[ -z $window_id ]]; then
		echo "Please specifiy a window id, you find this with 'xwininfo'"
		return 1
	fi

	local match_string='".*"'
	local match_int='[0-9][0-9]*'
	local match_qstring='"[^"\\]*(\\.[^"\\]*)*"'

	xprop -id $window_id | \
		sed -nr \
		-e "s/^WM_CLASS\(STRING\) = ($match_qstring), ($match_qstring)$/instance=\1\nclass=\3/p" \
		-e "s/^WM_WINDOW_ROLE\(STRING\) = ($match_qstring)$/window_role=\1/p" \
		-e "/^WM_NAME\(STRING\) = ($match_string)$/{s//title=\1/; h}" \
		-e "/^_NET_WM_NAME\(UTF8_STRING\) = ($match_qstring)$/{s//title=\1/; h}" \
		-e '${g; p}'
}

# dell_monitor: configura resolução 4K 30Hz num monitor Dell via xrandr
dell_monitor() {
	xrandr --newmode "3840x2160_30.00"  338.75  3840 4080 4488 5136  2160 2163 2168 2200 -hsync +vsync
	xrandr --addmode  DP1 "3840x2160_30.00"
	xrandr --output eDP1 --auto --primary --output DP1 --mode 3840x2160_30.00 --above eDP1 --rate 30
}
