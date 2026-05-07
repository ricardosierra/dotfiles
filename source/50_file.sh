#!/bin/bash

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
# permissões padrão: arquivos 644, pastas 755
umask 022

# Always use color output for `ls`
# ls colorido dependendo do OS
if is_osx; then
  alias ls="command ls -G"
else
  alias ls="command ls --color"
  export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

# List all files colorized in long format
# lista detalhada com cores
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
# inclui arquivos ocultos (.)
alias la="ls -laF ${colorflag}"

# ll: usa tree se disponível (mais bonito), senão ls -al
# lsd: lista só diretórios
if [[ "$(pinpoint tree)" ]]; then
  alias ll='tree --dirsfirst -aLpughDFiC 1'
  alias lsd='ll -d'
else
  alias ll='ls -al'
  alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
fi

# cl: cd e ls num comando só
# uso: cl [diretorio]  (padrão: $HOME)
cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null; ls
	else
		echo "bash: cl: $dir: Directory not found"
	fi
}

# =============================================================================
# Navegação rápida
# =============================================================================
# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"    # vai pra home (mais fácil de digitar que "cd")
alias -- -="cd -" # volta pro diretório anterior (como "cd -")

# tamanho de arquivo/diretório
alias fs="stat -f '%z bytes'"
alias df="df -h"   # uso de disco em formato legível

# Recursively delete `.DS_Store` files
# apaga todos os .DS_Store do diretório atual recursivamente (lixo do macOS)
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# assume ownership do diretório (troca pra seu usuário)
alias mine='sudo chown -R $USER'

# Enter in Directory without cd
# permite entrar em diretórios sem precisar digitar "cd"
shopt -s autocd

# Create a new directory and enter it
# cria a pasta e já entra nela
function md() {
  mkdir -p "$@" && cd "$@"
}

# =============================================================================
# z — "ajay/z": navegação por histórico de diretórios mais visitados
# uso: z proj  → vai pro diretório mais visitado que contém "proj"
# =============================================================================
mkdir -p $DOTFILES/caches/z
_Z_NO_PROMPT_COMMAND=1
_Z_DATA=$DOTFILES/caches/z/z
. $DOTFILES/vendor/z/z.sh

# =============================================================================
# Aliases para Debian/Linux (equivalentes de comandos macOS)
# =============================================================================
alias open='browser-exec "$@"'           # abre arquivos/URLs como no macOS
alias pbcopy='xclip -selection clipboard'   # copia pra área de transferência
alias pbpaste='xclip -selection clipboard -o'  # cola da área de transferência

# atalhos de navegação comuns
alias dl="cd ~/Downloads"  # vai pra Downloads
alias h="history"          # histórico de comandos

# detecta qual flavor de `ls` está disponível (GNU vs BSD)
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# Always enable colored `grep` output
alias grep='grep --color=auto '

# Enable aliases to be sudo'ed
# permite usar aliases com sudo (ex: sudo ll)
alias sudo='sudo '

# número da semana atual
alias week='date +%V'

# cronômetro simples: Ctrl-D para parar
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# =============================================================================
# Rede e IPs
# =============================================================================
# IP público via OpenDNS
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"

# IP local (exclui loopback)
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# todos os IPs (IPv4 e IPv6)
alias ips="sudo ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
# limpa o cache de DNS no macOS
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# View HTTP traffic
# snifa tráfego HTTP na en1 (GET e POST)
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# =============================================================================
# Utilitários de sistema
# =============================================================================
# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"  # dump hexadecimal

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Trim new lines and copy to clipboard
# remove quebras de linha e copia pro clipboard
alias c="tr -d '\n' | xclip -selection clipboard"

# URL-encode strings
# encode uma string pra usar em URLs
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# junta PDFs num único arquivo
# uso: mergepdf -o saida.pdf entrada1.pdf entrada2.pdf
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
# aplica um comando em cada item via xargs (ex: find . -name "*.js" | map wc -l)
alias map="xargs -n1"

# One of @janmoesen's ProTip™s
# aliases HTTP: GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS como comandos diretos
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

# Kill all the tabs in Chrome to free up memory
# mata todos os tabs do Chrome (só renderizadores, não extensões)
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Lock the screen (when going AFK)
# trava a tela com fundo preto (i3lock)
alias afk="i3lock -c 000000"

# edita o /etc/hosts com sudo no vim
alias hosts='sudo vim /etc/hosts'

# copy working directory
# copia o caminho do diretório atual pro clipboard
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

# copy file interactive — confirma antes de sobrescrever
alias cp='cp -i'

# move file interactive — confirma antes de sobrescrever
alias mv='mv -i'

# extrai tar sem precisar lembrar as flags
alias untar='tar xvf'

# copia a chave pública SSH pro clipboard
alias pubkey="more ~/.ssh/id_rsa.pub | xclip -selection clipboard | echo '=> Public key copied to pasteboard.'"

# copia a chave privada SSH pro clipboard (cuidado!)
alias prikey="more ~/.ssh/id_rsa | xclip -selection clipboard | echo '=> Private key copied to pasteboard.'"

# =============================================================================
# Tamanho de arquivos
# =============================================================================
# Determine size of a file or total size of a directory
alias fs=filesize
filesize() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh  # GNU du: tamanho total em formato legível
	else
		local arg=-sh   # BSD du
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *  # mostra tudo (incluindo arquivos ocultos)
	fi
}

# Create a new directory and enter it
# cria pasta e entra nela (alternativa ao md())
mkd() {
	mkdir -p "$@" && cd "$@"
}

# Make a temporary directory and enter it
# cria pasta temporária e entra nela — útil pra testes rápidos
# uso: tmpd [prefixo]
tmpd() {
	if [ $# -eq 0 ]; then
		dir=`mktemp -d` && cd $dir
	else
		dir=`mktemp -d -t $1.XXXXXXXXXX` && cd $dir
	fi
}

# =============================================================================
# Arquivos comprimidos
# =============================================================================

# extract: descomprime qualquer formato de arquivo sem precisar lembrar os flags
# uso: extract arquivo.tar.gz  (suporta: zip, rar, bz2, gz, tar, 7z, xz, etc.)
function extract {
 if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        case "$1" in
          *.tar.bz2)   tar xvjf "$1"    ;;
          *.tar.gz)    tar xvzf "$1"    ;;
          *.tar.xz)    tar xvJf "$1"    ;;
          *.lzma)      unlzma "$1"      ;;
          *.bz2)       bunzip2 "$1"     ;;
          *.rar)       unrar x -ad "$1" ;;
          *.gz)        gunzip "$1"      ;;
          *.tar)       tar xvf "$1"     ;;
          *.tbz2)      tar xvjf "$1"    ;;
          *.tgz)       tar xvzf "$1"    ;;
          *.zip)       unzip "$1"       ;;
          *.Z)         uncompress "$1"  ;;
          *.7z)        7z x "$1"        ;;
          *.xz)        unxz "$1"        ;;
          *.exe)       cabextract "$1"  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "'$1' - file does not exist"
    fi
 fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
# targz: cria .tar.gz usando o melhor compressor disponível (zopfli > pigz > gzip)
# zopfli é melhor pra arquivos pequenos; pigz é paralelo e mais rápido pra grandes
targz() {
	local tmpFile="${@%/}.tar"
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

	size=$(
	stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
	stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	)

	local cmd=""
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# arquivo menor que 50MB: usa zopfli (melhor compressão)
		cmd="zopfli"
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz"   # paralelo, rápido pra arquivos grandes
		else
			cmd="gzip"   # fallback universal
		fi
	fi

	echo "Compressing .tar using \`${cmd}\`…"
	"${cmd}" -v "${tmpFile}" || return 1
	[ -f "${tmpFile}" ] && rm "${tmpFile}"
	echo "${tmpFile}.gz created successfully."
}

# Create a data URL from a file
# dataurl: converte um arquivo em Data URL base64 e copia pro clipboard
# uso: dataurl imagem.png
dataurl() {
	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
    localbase64="data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
	echo "$localbase64" | xclip -selection clipboard | echo '=> Base64 copied to pasteboard.'
}

# Use feh to nicely view images
# openimage: abre imagens com feh (viewer leve, suporte a slideshow)
# uso: openimage foto.jpg
openimage() {
	local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	cd $(dirname "$1")
	local file=$(basename "$1")

	feh -q $types --auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}

# =============================================================================
# Notas e tarefas simples em ~/.notes e ~/.todo
# =============================================================================

# note: bloco de notas rápido salvo em ~/.notes
# uso:
#   note              → mostra todas as notas
#   note minha nota   → adiciona uma nota
#   note -c           → limpa todas as notas
note () {
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        printf "%s" > "$HOME/.notes"
    else
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}

# todo: lista de tarefas simples salva em ~/.todo
# uso:
#   todo              → mostra as tarefas
#   todo minha tarefa → adiciona uma tarefa
#   todo -l           → lista numerada
#   todo -c           → limpa tudo
#   todo -r           → remove uma tarefa pelo número
todo() {
    if [[ ! -f $HOME/.todo ]]; then
        touch "$HOME/.todo"
    fi

    if ! (($#)); then
        cat "$HOME/.todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/.todo"   # lista com números
    elif [[ "$1" == "-c" ]]; then
        > $HOME/.todo           # limpa o arquivo
    elif [[ "$1" == "-r" ]]; then
        # pede o número da tarefa pra remover
        nl -b a "$HOME/.todo"
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
        read -p "Type a number to remove: " number
        sed -i ${number}d $HOME/.todo "$HOME/.todo"
    else
        printf "%s\n" "$*" >> "$HOME/.todo"
    fi
}
