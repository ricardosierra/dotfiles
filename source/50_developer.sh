
# =============================================================================
# Desenvolvimento — HTTP server, C, Go e navegação em projetos
# =============================================================================

# server: sobe um servidor HTTP simples no diretório atual
# uso: server [porta]  (padrão: 8000)
# usa Python 2 SimpleHTTPServer com UTF-8 e text/plain como Content-Type padrão
server() {
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# csource: compila e executa um arquivo C na hora, sem deixar rastro
# compila em /tmp e apaga o binário após executar
# uso: csource arquivo.c
csource() {
	[[ $1 ]]    || { echo "Missing operand" >&2; return 1; }
	[[ -r $1 ]] || { printf "File %s does not exist or is not readable\n" "$1" >&2; return 1; }
	local output_path=${TMPDIR:-/tmp}/${1##*/};
	gcc "$1" -o "$output_path" && "$output_path";
	rm "$output_path";
	return 0;
}

# =============================================================================
# Go
# =============================================================================

# gostatic: gera binário estático do Go (sem dependências dinâmicas)
# ideal pra distribuir pra qualquer Linux sem precisar instalar libs
# uso: gostatic [diretorio] [netgo|cgo]
#   gostatic           — usa o diretório atual, CGO desabilitado
#   gostatic . netgo   — usa tags netgo (resolve DNS internamente)
#   gostatic . cgo     — usa CGO com linking estático
gostatic(){
	local dir=$1
	local arg=$2

	if [[ -z $dir ]]; then
		dir=$(pwd)
	fi

	local name=$(basename "$dir")
	(
	cd $dir
	export GOOS=linux
	echo "Building static binary for $name in $dir"

	case $arg in
		"netgo")
			set -x
			go build -a \
				-tags 'netgo static_build' \
				-installsuffix netgo \
				-ldflags "-w" \
				-o "$name" .
			;;
		"cgo")
			set -x
			CGO_ENABLED=1 go build -a \
				-tags 'cgo static_build' \
				-ldflags "-w -extldflags -static" \
				-o "$name" .
			;;
		*)
			# modo padrão: CGO desabilitado, mais portável
			set -x
			CGO_ENABLED=0 go build -a \
				-installsuffix cgo \
				-ldflags "-w" \
				-o "$name" .
			;;
	esac
	)
}

# gogo: vai pra pasta de um projeto Go no $GOPATH com facilidade
# aceita nome parcial, GitHub URL ou só o nome do projeto
# uso: gogo meu-projeto  ou  gogo github.com/user/repo
gogo(){
	local d=$1

	if [[ -z $d ]]; then
		echo "You need to specify a project name."
		return 1
	fi

	# aceita "github.com/user/repo" e extrai só o nome do repo
	if [[ "$d" == github* ]]; then
		d=$(echo $d | sed 's/.*\///')
	fi
	d=${d%/}

	# busca no GOPATH inteiro, ordena por comprimento de path (pega o mais raso primeiro)
	local path=( `find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

	if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
		echo "Could not find a directory named $d in $GOPATH"
		echo "Maybe you need to 'go get' it ;)"
		return 1
	fi

	cd "${path[0]}"
}

# golistdeps: lista todas as dependências externas do projeto atual (ou de um projeto Go)
golistdeps(){
	(
	if [[ ! -z "$1" ]]; then
		gogo "$@"
	fi

	go list -e -f '{{join .Deps "\n"}}' ./... | xargs go list -e -f '{{if not .Standard}}{{.ImportPath}}{{end}}'
	)
}
