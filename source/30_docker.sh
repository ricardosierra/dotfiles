
# =============================================================================
# Docker — aliases e funções pra agilizar o dia a dia
# =============================================================================

# executa container interativo e apaga ao sair (--rm)
alias drun='docker run -it --rm'

# =============================================================================
# Docker Machine (legado — pré-Docker Desktop)
# =============================================================================
alias dmachine='cd ~/Downloads/dmachine'
alias dm='sudo docker-machine '        # docker-machine com sudo
alias dml='docker-machine ls '         # lista as máquinas
alias devstar='docker-machine start dev'  # inicia a máquina "dev"
alias denv='env | grep  DOCKER'        # mostra variáveis de ambiente docker
alias dkenv='eval "$(sudo docker-machine env dev)"'  # ativa o ambiente da máquina dev
alias dmc='docker-machine create '     # cria nova máquina
alias dmip='docker-machine ip '        # IP de uma máquina
alias dmub='docker run -d -p ubuntu /bin/bash'
alias dmstar='docker-machine start '   # inicia uma máquina
alias dmstop='docker-machine stop '    # para uma máquina
alias mstar='docker-machine start '    # atalho alternativo
alias mstop='docker-machine stop '     # atalho alternativo

# =============================================================================
# IP dos containers
# =============================================================================
alias dc="dockexec"
alias docker_exec="dockexec"

# abre bash no último container criado
dockexecl() { docker exec -i -t "$(docker ps -l -q)" bash ;}

# abre bash no container passado como argumento
dockexec() { docker exec -i -t "$@" bash ;}

# pega o IP de um container pelo ID
alias dockip='docker inspect --format "{{ .NetworkSettings.IPAddress }}"'

# IP de todos os containers em execução
alias dockipl='docker inspect --format "{{ .NetworkSettings.IPAddress }}" $(docker ps -q)'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}" '
alias dipl='docker inspect  $(docker ps -qq) | grep IPAddress'

# =============================================================================
# Start/Stop de containers
# =============================================================================
alias mstar1='docker-machine start $(docker-machine ls | tail -1 | awk "{print $1}")'
alias mstop1='docker-machine stop $(docker-machine ls | tail -1 | awk "{print $1}")'
alias dmk='docker-machine kill'

# para e remove todos os containers graciosamente
alias dra='docker rm $(docker stop $(docker ps -aq))'

# mata e remove todos os containers na marra
alias drk='docker rm $(docker kill $(docker ps -aq))'

# inspeciona a última máquina Docker Machine criada
alias dmin='docker-machine inspect $(docker-machine ls | tail -1 | awk "{print $1}")'

# remove a última máquina Docker Machine
alias dmrm='docker-machine rm $(docker-machine ls | tail -1 | awk "{print $1}")'

# =============================================================================
# Redes Docker
# =============================================================================
alias dnr='docker network rm'      # remove uma rede
alias dnl='docker network ls'      # lista as redes
alias dnc='docker network create'  # cria uma rede
alias dni='docker network inspect' # inspeciona uma rede
alias dnia='docker network inspect $(docker network ls -q)'  # inspeciona todas
alias dnrm='docker network rm $(docker network ls -q)'       # remove todas

# =============================================================================
# Engine Docker — imagens e containers
# =============================================================================
alias di='docker images'           # lista imagens
alias di5='docker images | head -n5'  # últimas 5 imagens

# inicia/para TODOS os containers de uma vez
alias start='docker start $(docker ps -qa)'
alias stop='docker stop $(docker ps -qa)'

# inicia/para apenas o ÚLTIMO container
alias startl='docker start $(docker ps -qal)'
alias stopl='docker stop $(docker ps -qal)'

alias dl='docker logs '            # logs de um container
alias dri='docker rmi '            # remove imagem
alias dr='docker rm -f '           # remove container forçado
alias dls='docker ps -a '          # lista todos os containers
alias dlsl='docker ps -l '         # último container
alias dcount='docker ps -qa | wc -l'  # quantidade de containers
alias dtop='docker stop '          # para um container específico
alias din='docker inspect '        # inspeciona um container
alias dp='docker port $(docker ps -l -q)'   # portas do último container
alias db='docker build -t '        # build com tag
alias dbc='docker build -t --no-cache '  # build sem cache
alias drl='docker rm -f `docker ps -ql`'    # remove o último container
alias drall='docker rm -f `docker ps -qa`'  # remove todos os containers

# dexec: abre bash num container buscando pelo nome (busca parcial)
# uso: dexec nginx  (abre bash no container cujo nome contém "nginx")
dexec() {
  if [ -z "$1" ]; then
    echo "Uso: dexec <parte-do-nome-do-container>"
    return 1
  fi
  ID=$(docker ps --format "{{.ID}} {{.Names}}" | grep "$1" | awk '{print $1}')
  if [ -z "$ID" ]; then
    echo "Container com nome contendo '$1' não encontrado."
    return 1
  fi
  docker exec -it "$ID" bash
}

# shell /bin/sh no último container (útil pra Alpine que não tem bash)
dexl() { docker exec -i -t $(docker ps -l -q) /bin/sh ;}

# shell /bin/sh num container específico
dex() { docker exec -i -t $@ /bin/sh ;}

alias dlog='docker logs $(docker ps -l -q)'  # logs do último container
alias drun='docker run -i -t -name '
alias dport='docker port $(docker ps -l -q)'  # portas do último container

# inspeciona o último container criado
alias dinl='docker inspect $(docker ps -qal)'

# inspeciona todos os containers em execução
alias dina='docker inspect $(docker ps -qa)'

# lista os IPs de todos os containers em execução
alias dnip='docker inspect $(docker ps -qa) | grep IPA | grep [0-9]'

# mostra subnets e gateways de todas as redes Docker
alias dnnet='docker network inspect $(docker network ls -q) | grep "Subnet\|Gateway"'

# =============================================================================
# Shells de SO sob demanda — containers que se destroem ao sair (--rm)
# =============================================================================
alias alpinerm='docker run -it --rm alpine /bin/sh'
alias ubunturm='docker run -it --rm ubuntu'
alias debianrm='docker run -it --rm debian'
alias fedorarm='docker run -it --rm fedora'
alias centosrm='docker run -it --rm centos'
alias busyrm='docker run -it --rm busybox'
alias nethostrm='docker run -it --rm --net=host ubuntu'  # compartilha rede do host

# containers que param mas não são removidos ao sair
alias alpine='docker run -it alpine /bin/sh'
alias ubuntu='docker run -it ubuntu'
alias debian='docker run -it debian'
alias fedora='docker run -it fedora'
alias busy='docker run -it busybox'
alias nethost='docker run -it --net=host ubuntu'

# containers em modo daemon (background, ficam rodando)
alias alpined='docker run -itd alpine /bin/sh'
alias ubuntud='docker run -itd ubuntu'
alias debiand='docker run -itd debian'
alias fedorad='docker run -itd fedora'
alias busyd='docker run -itd busybox'

# =============================================================================
# Funções de limpeza e gerenciamento
# =============================================================================

# delcon: remove containers que batem com o filtro passado
# uso: delcon ubuntu  (remove todos com "ubuntu" no nome/imagem)
delcon() { docker rm -f $(docker ps  -a | grep $@ | awk '{print $1}') ;}

# stopcon: para containers que batem com o filtro
stopcon() { docker stop $(docker ps  -a | grep $@ | awk '{print $1}') ;}

# delnone: apaga todas as imagens órfãs (tag <none>) — sobras de builds quebrados
delnone() { docker rmi $(docker images | grep none | awk '{print $3}') ;}

# delimg: apaga imagens que batem com o filtro
# uso: delimg nginx
delimg() { docker rmi $(docker images | grep $@ | awk '{print $3}') ;}

# conta conexões abertas no processo do Docker (útil pra debugar leaks)
alias conns="sudo lsof -a -p $(pidof docker) | wc -l"
alias conns2="lsof -a -p $(ps -e | grep docker | awk '{print $1}' | head -n1) | wc  -l"

# docker-compose shortcuts
alias up='docker-compose up -d'     # sobe os serviços em background
alias down='docker-compose down'    # derruba os serviços

alias images='docker images'

# =============================================================================
# Funções helper para gerenciamento de imagens locais
# =============================================================================

# builda todas as imagens definidas em $docker_programs
docker_build_all(){
    for elt in "${docker_programs[@]}";do
        echo "Fazendo Build de: $elt"
        images_local_build $elt;
    done
}

# dcleanup: remove containers parados e imagens dangling (layers soltas)
dcleanup(){
	docker rm $(docker ps -aq 2>/dev/null) 2>/dev/null
	docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
	docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

# dclean_container: remove todos os containers (incluindo parados)
dclean_container(){
  docker rm $(docker ps -a -q)
}

# dcleanall: remove containers + imagens — limpa tudo de uma vez
dcleanall(){
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
}

# images_remote_build: placeholder pra rodar programas via imagem remota
images_remote_build(){
	local repository=$1
	local programName=$2

  echo "Running $programName with Docker"
}

# images_local_build: builda uma imagem local a partir de $DOCKERFILES_PATH/<nome>
# só builda se a imagem ainda não existir (idempotente)
images_local_build(){
    local name=$1
    local version=$2

    # versão vira subpasta (ex: nginx/1.21)
    if [[ "$version" != "" ]]; then
        directory="${name}/${version}"
        contname="${name}:${version}"
    else
        directory="${name}"
        contname="${name}"
    fi

    if [ ! -d "${DOCKERFILES_PATH}/${directory}" ]; then
        echo "Erro - Dockerfile not found: "$directory
        return 1
    fi

    if [[ "$(docker images -q $contname 2> /dev/null)" == "" ]]; then
        echo "Docker Build: ${directory}"
        docker build --disable-content-trust -t $contname ${DOCKERFILES_PATH}/${directory}
    fi
}

# del_stopped: remove um container se ele estiver parado
del_stopped(){
	local name=$1
	local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null)

	if [[ "$state" == "false" ]]; then
		docker rm $name
	fi
}

# relies_on: garante que containers dependentes estejam rodando antes de continuar
relies_on(){
	local containers=$@

	for container in $containers; do
		local state=$(docker inspect --format "{{.State.Running}}" $container 2>/dev/null)

		if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
			echo "$container is not running, starting it for you."
			$container
		fi
	done
}

# nginx_config: cria config nginx pra rotear um domínio local pra uma rota interna
nginx_config(){
	server=$1
	route=$2

	cat >${HOME}/.nginx/conf.d/${server}.conf <<-EOF
	upstream ${server} { server ${route}; }
	server {
            server_name ${server};
            location / {
                proxy_pass  http://${server};
                proxy_http_version 1.1;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host \$http_host;
                proxy_set_header X-Forwarded-Proto \$scheme;
                proxy_set_header X-Forwarded-For \$remote_addr;
                proxy_set_header X-Forwarded-Port \$server_port;
                proxy_set_header X-Request-Start \$msec;
            }
	}
	EOF

	docker restart nginx

	# adiciona o servidor em /etc/hosts
	sudo hostess add $server 127.0.0.1

	browser-exec "http://${server}"
}

# de: abre bash no container do serviço docker-compose do diretório atual
# uso: de <nome-do-servico>  (ex: de app, de db, de nginx)
# descobre o nome do projeto pelo nome da pasta atual (em lowercase)
function de() {
  local result=$(get-actual-directory)
  result=$(strtolower $result)

  docker exec -it ${result}_${1}_1 bash
}
