
alias drun='docker run -it --rm'

# Docker Machine
alias dmachine='cd ~/Downloads/dmachine'
alias dm='sudo docker-machine '
alias dml='docker-machine ls '
alias devstar='docker-machine start dev'
alias denv='env | grep  DOCKER'
alias dkenv='eval "$(sudo docker-machine env dev)"'
alias dmc='docker-machine create '
alias dmip='docker-machine ip '
alias dmub='docker run -d -p ubuntu /bin/bash'
alias dmstar='docker-machine start '
alias dmstop='docker-machine stop '
alias mstar='docker-machine start '
alias mstop='docker-machine stop '

# GetIP addresses
alias dc="dockexec"
alias docker_exec="dockexec"
dockexecl() { docker exec -i -t $(docker ps -l -q) bash ;}
dockexec() { docker exec -i -t $@ bash ;}
alias dockip='docker inspect --format "{{ .NetworkSettings.IPAddress }}"'
alias dockipl='docker inspect --format "{{ .NetworkSettings.IPAddress }}" $(docker ps -q)'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}" '
alias dipl='docker inspect  $(docker ps -qq) | grep IPAddress'

# Start/Stop the  containers
alias mstar1='docker-machine start $(docker-machine ls | tail -1 | awk "{print $1}")'
alias mstop1='docker-machine stop $(docker-machine ls | tail -1 | awk "{print $1}")'
alias dmk='docker-machine kill'
# Gracefully stop and delete all container
alias dra='docker rm $(docker stop $(docker ps -aq))'
# Kill and delete all containers
alias drk='docker rm $(docker kill $(docker ps -aq))'

# Inspect the last container created
alias dmin='docker-machine inspect $(docker-machine ls | tail -1 | awk "{print $1}")'

# Remove the last container created
alias dmrm='docker-machine rm $(docker-machine ls | tail -1 | awk "{print $1}")'

# Docker Network aliases
alias dnr='docker network rm'
alias dnl='docker network ls'
alias dnc='docker network create'
alias dni='docker network inspect'
alias dnia='docker network inspect $(docker network ls -q)'
alias dnrm='docker network rm $(docker network ls -q)'

# Docker Engine aliases
alias di='docker images'
alias di5='docker images | head -n5'
# start/stop all containers
alias start='docker start $(docker ps -qa)'
alias stop='docker stop $(docker ps -qa)'
# start/stop last containers
alias startl='docker start $(docker ps -qal)'
alias stopl='docker stop $(docker ps -qal)'
alias dl='docker logs '
alias dri='docker rmi '
alias dr='docker rm -f '
alias dls='docker ps -a '
alias dlsl='docker ps -l '
alias dcount='docker ps -qa | wc -l'
alias dtop='docker stop '
alias din='docker inspect '
alias dp='docker port $(docker ps -l -q)'
alias db='docker build -t '
alias dbc='docker build -t --no-cache '
alias drl='docker rm -f `docker ps -ql`'
alias drall='docker rm -f `docker ps -qa`'
alias dexec='docker exec '
dexl() { docker exec -i -t $(docker ps -l -q) /bin/sh ;}
dex() { docker exec -i -t $@ /bin/sh ;}
alias dlog='docker logs $(docker ps -l -q)'
alias drun='docker run -i -t -name '
alias dport='docker port $(docker ps -l -q)'

# Docker inspect the last container created
alias dinl='docker inspect $(docker ps -qal)'
# Docker inspect all containers
alias dina='docker inspect $(docker ps -qa)'

# Inspect and parse all IPs for all containers
alias dnip='docker inspect $(docker ps -qa) | grep IPA | grep [0-9]'

# Example Docker network inspect all network subnets
alias dnnet='docker network inspect $(docker network ls -q) | grep "Subnet\|Gateway"'

# On demand foreground OS bash shells that delete on shell exit
alias alpinerm='docker run -it --rm alpine /bin/sh'
alias ubunturm='docker run -it --rm ubuntu'
alias debianrm='docker run -it --rm debian'
alias fedorarm='docker run -it --rm fedora'
alias centosrm='docker run -it --rm centos'
alias busyrm='docker run -it --rm busybox'
alias nethostrm='docker run -it --rm --net=host ubuntu'

# On demand foreground OS bash shells that stops on shell exit
alias alpine='docker run -it alpine /bin/sh'
alias ubuntu='docker run -it ubuntu'
alias debian='docker run -it debian'
alias fedora='docker run -it fedora'
alias busy='docker run -it busybox'
alias nethost='docker run -it --net=host ubuntu'

# On demand background OS bash shells running in daemon mode
alias alpined='docker run -itd alpine /bin/sh'
alias ubuntud='docker run -itd ubuntu'
alias debiand='docker run -itd debian'
alias fedorad='docker run -itd fedora'
alias busyd='docker run -itd busybox'

# Delete all containers matching the passed paramater
# Example: "delcon ubuntu" or 'anything matching in docker ps output'
delcon() { docker rm -f $(docker ps  -a | grep $@ | awk '{print $1}') ;}

# Stop all containers matching the passed paramater.
stopcon() { docker stop $(docker ps  -a | grep $@ | awk '{print $1}') ;}

# Delete all with a <none> label bad makes will orphan a 'none' img
delnone() { docker rmi $(docker images | grep none | awk '{print $3}') ;}
# Delete all images matching the arg passed after 'delimg none'
delimg() { docker rmi $(docker images | grep $@ | awk '{print $3}') ;}

# Find all orphaned files, tcp or http connections not being properly closed
alias conns="sudo lsof -a -p $(pidof docker) | wc -l"
# Same as above for unclosed threads but more generic name to pid match such as docker-dev-1.x
alias conns2="lsof -a -p $(ps -e | grep docker | awk '{print $1}' | head -n1) | wc  -l"

#docker-compose
alias up='docker-compose up -d'
alias down='docker-compose down'

alias images='docker images'

#
# Helper Functions
#
docker_build_all(){
    for elt in "${docker_programs[@]}";do
        echo "Fazendo Build de: $elt"
        images_local_build $elt;
    done
}

# Remove todas as camadas intermediárias dos containers
dcleanup(){
	docker rm $(docker ps -aq 2>/dev/null) 2>/dev/null
	docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
	docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

# Limpa (Removendo) os containers
dclean_container(){
  docker rm $(docker ps -a -q)
}

# Limpa Tudo
dcleanall(){
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
}

# Comando para Rodar um Programa usando uma imagem da internet
images_remote_build(){
	local repository=$1
	local programName=$2

  echo "Running $programName with Docker"
}

# Comando para Rodar um Programa usando uma imagem da internet
images_local_build(){
    local name=$1
    local version=$2

    #Versão vira uma subpasta do repositorio
    if [[ "$version" != "" ]]; then
        directory="${name}/${version}"
				contname="${name}:${version}"
    else
        directory="${name}"
				contname="${name}"
    fi
    #Se a pasta não existe, returna sem buildar nada
    if [ ! -d "${DOCKERFILES_PATH}/${directory}" ]; then
        echo "Erro - Dockerfile not found: "$directory
        return 1
    fi

    if [[ "$(docker images -q $contname 2> /dev/null)" == "" ]]; then
                  echo "Docker Build: ${directory}"
      docker build --disable-content-trust -t $contname ${DOCKERFILES_PATH}/${directory}
    fi
}

del_stopped(){
	local name=$1
	local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null)

	if [[ "$state" == "false" ]]; then
		docker rm $name
	fi
}
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
# creates an nginx config for a local route
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

	# restart nginx
	docker restart nginx

	# add host to /etc/hosts
	sudo hostess add $server 127.0.0.1

	# open browser
	browser-exec "http://${server}"
}
