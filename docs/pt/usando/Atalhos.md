


# Docker


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