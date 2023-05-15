#!/bin/bash
# # Bash wrappers for docker run commands

# #alias composer="docker run --rm -u $UID -v $PWD:/app composer/composer"
# #alias node="docker run -ti --rm -u $UID -v `pwd`:/data dragonmantank/nodejs-grunt-bower node"
# #alias grunt="docker run -ti --rm -u $UID -v `pwd`:/data dragonmantank/nodejs-grunt-bower grunt"
# #alias npm="docker run -ti --rm -u $UID -v `pwd`:/data dragonmantank/nodejs-grunt-bower npm"
# #alias bower="docker run -ti --rm -u $UID -v `pwd`:/data dragonmantank/nodejs-grunt-bower bower"

export DOCKER_REPO_PREFIX=sierratecnologia/
export DOCKERFILES_PATH=~/.dockerfiles

# if is_windows; then
#     return ;
# fi

# # All Docker Programs
# docker_programs=(
#     "android-studio"
#     "apt-file"
#     atom
#     audacity
#     aws
#     bees
#     cadvisor
#     cheese
#     chrome
#     clementine
#     composer
#     consul
#     cordova
#     dcos-cli
#     dbvis
#     dia
#     firefox
#     gcalcli
#     gcloud
#     gimp
#     gitk
#     hollywood
#     htop
#     httpie
#     imagemin
#     irssi
#     john
#     kernel-builder
#     kicad
#     kvm
#     libreoffice
#     lpass
#     lynx
#     masscan
#     maltego
#     mpd
#     "mysql-workbench"
#     "mutt"
#     ncmpc
#     neoman
#     nes
#     netbeans
#     "netbeans-php"
#     netcat
#     nginx
#     nmap
#     "notify-osd"
#     pandoc
#     php
#     phpmyadmin
#     phonegap
#     pivmanpms
#     pond
#     privoxy
#     pulseaudio
#     rainbowstream
#     registrator
#     remmina
#     ricochet
#     rstudio
#     s3cmd
#     scilab
#     scudcloud
#     shorewall
#     skype
#     slack
#     spotify
#     "sublime-text-3"
#     john
#     steam
#     t
#     tarsnap
#     telnet
#     termboy
#     thunderbird
#     tor
#     tor-browser
#     tor-messenger
#     tor-proxy
#     traceroute
#     transmission
#     "libvirt-client"
#     "virt-viewer"
#     visualstudio
#     vlc
#     warzone2100
#     watchman
#     wireshark
#     wrk
#     yhpersonalize
#     yubico-piv-tool
# )

#
# Container Aliases
#
android-studio(){
    if [[ "$(pinpoint android-studio)" ]]; then
        command android-studio "$@"
        return 
    fi
    docker run -rm -ti \
	  --privileged \
	  -v $HOME/AndroidStudioProjects:/home/ubuntu/AndroidStudioProjects \
	  -v $HOME/.android:/home/ubuntu/.android \
	  -v $HOME/.AndroidStudio3.0:/home/ubuntu/.AndroidStudio3.0 \
	  -v /dev/bus/usb:/dev/bus/usb \
	  -v /dev/kvm:/dev/kvm \
	  -v $ANDROID_HOME:/opt/android-sdk \
	  -e DISPLAY=$DISPLAY \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  -v $XAUTHORITY:/home/ubuntu/.Xauthority \
	  -v `pwd`:/data \
	  --net host \
	  sierratecnologia/android-studio:3.0 "$@"
}
apt_file(){
    images_local_build apt-file
    docker run --rm -it \
        --user $(id -u):$(id -g) \
        --name apt-file \
        ${DOCKER_REPO_PREFIX}apt-file
}
alias a=atom
atom(){
    if [[ "$(pinpoint atom)" ]]; then
        command atom "$@"
        return 
    fi
    images_local_build atom

    docker run -d -ti \
        --user $(id -u):$(id -g) \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v `pwd`:/var/www \
        ${DOCKER_REPO_PREFIX}atom "$@"
}
alias apt-file="apt_file"
audacity(){
    if [[ "$(pinpoint audacity)" ]]; then
        command audacity "$@"
        return 
    fi
    images_local_build audacity
    del_stopped audacity

    relies_on pulseaudio

    docker run -d \
        --user $(id -u):$(id -g) \
            -v /etc/localtime:/etc/localtime:ro \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v `pwd`:/home/root \
            -e DISPLAY=unix$DISPLAY \
            -e QT_DEVICE_PIXEL_RATIO \
            --device /dev/snd \
            --link pulseaudio:pulseaudio \
            -e PULSE_SERVER=pulseaudio \
            --group-add audio \
            --name audacity \
            ${DOCKER_REPO_PREFIX}audacity
}
aws(){
    images_local_build aws
    docker run -it --rm \
        --user $(id -u):$(id -g) \
            -v $HOME/.aws:/root/.aws \
            --log-driver none \
            --name aws \
            ${DOCKER_REPO_PREFIX}awscli "$@"
}
bees(){
    images_local_build bees
    docker run -it --rm \
        --user $(id -u):$(id -g) \
            -e NOTARY_TOKEN \
            -v $HOME/.bees:/root/.bees \
            -v $HOME/.boto:/root/.boto \
            -v $HOME/.dev:/root/.ssh:ro \
            --log-driver none \
            --name bees \
            ${DOCKER_REPO_PREFIX}beeswithmachineguns "$@"
}
cadvisor(){
    images_local_build cadvisor
    docker run -d \
        --user $(id -u):$(id -g) \
            --restart always \
            -v /:/rootfs:ro \
            -v /var/run:/var/run:rw \
            -v /sys:/sys:ro  \
            -v /var/lib/docker/:/var/lib/docker:ro \
            -p 1234:8080 \
            --name cadvisor \
            google/cadvisor

    sudo hostess add cadvisor $(docker inspect --format "{{.NetworkSettings.Networks.bridge.IPAddress}}" cadvisor)
    browser-exec "http://cadvisor:8080"
}
cheese(){
    if [[ "$(   c)" ]]; then
        command cheese "$@"
        return 
    fi
    images_local_build cheese
    del_stopped cheese

    docker run -d \
        --user $(id -u):$(id -g) \
            -v /etc/localtime:/etc/localtime:ro \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -e DISPLAY=unix$DISPLAY \
            -v $HOME/$DOTFILES_FOLDER_PICTURES:/root/Pictures \
            --device /dev/video0 \
            --device /dev/snd \
            --device /dev/dri \
            --name cheese \
            ${DOCKER_REPO_PREFIX}cheese
}
# alias google-chrome="chrome"
# chrome(){
#     if [[ "$(pinpoint google-chrome)" ]] && [[ "$1" != "tor" ]]; then
#         command google-chrome "$@" &> /dev/null
#         return 
#     fi
#     images_local_build chrome stable
#     # add flags for proxy if passed
#     local proxy=
#     local map=
#     local args=$@
#     if [[ "$1" == "tor" ]]; then
#         relies_on torproxy

#         map="MAP * ~NOTFOUND , EXCLUDE torproxy"
#         proxy="socks5://torproxy:9050"
#         args="https://check.torproject.org/api/ip ${@:2}"
#     fi

#     del_stopped chrome

#     # one day remove /etc/hosts bind mount when effing
#     # overlay support inotify, such bullshit
#     sudo docker run -d \
#         --user $(id -u):$(id -g) \
#         --memory 2gb \
#         -v /etc/localtime:/etc/localtime:ro \
#         -v /tmp/.X11-unix:/tmp/.X11-unix \
#         -e DISPLAY=unix$DISPLAY \
#         -v $HOME/Downloads:/root/Downloads \
#         -v $HOME/$DOTFILES_FOLDER_PICTURES:/root/Pictures \
#         -v $HOME/Torrents:/root/Torrents \
#         -v $HOME/.chrome:/data \
#         -v /dev/shm:/dev/shm \
#         -v /etc/hosts:/etc/hosts \
#         --security-opt seccomp:/etc/docker/seccomp/chrome.json \
#         --device /dev/snd \
#         --device /dev/dri \
#         --device /dev/video0 \
#         --device /dev/usb \
#         --device /dev/bus/usb \
#         --group-add audio \
#         --group-add video \
#         --name chrome \
#         ${DOCKER_REPO_PREFIX}chrome --user-data-dir=/data \
#         --proxy-server="$proxy" \
#         --host-resolver-rules="$map" $args &> /dev/null
# }
clementine(){
    if [[ "$(pinpoint clementine)" ]]; then
        command clementine "$@"
        return 
    fi
    images_local_build clementine
    
    relies_on pulseaudio

    docker run -d \
        --user $(id -u):$(id -g) \
            -v /etc/localtime:/etc/localtime:ro \
            -e DISPLAY=$DISPLAY \
            --device /dev/snd \
            --link pulseaudio:pulseaudio \
            -e PULSE_SERVER=pulseaudio \
            --group-add audio \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $HOME/Musicas:/root/Music \
            ${DOCKER_REPO_PREFIX}clementine "$@"
}

# composer(){
#     if [[ "$(pinpoint composer)" ]]; then
#             command composer "$@"
#             return
#     fi


#     argument="$@"
#     if [[ "$1" = "install" ]] || [[ "$1" = "update" ]] || [[ "$2" = "require" ]]; then
#       argument="--ignore-platform-reqs --no-scripts $@"
#     fi
#     if [[ "$1" = "global" ]] || [[ "$1" = "GLOBAL" ]]; then
#         if [[ "$2" = "install" ]] || [[ "$2" = "update" ]] || [[ "$2" = "require" ]]; then
#           argument="--ignore-platform-reqs --no-scripts $@"
#         fi
#     fi

#     tty=
#     tty -s && tty=--tty
#     docker run \
#         $tty \
#         --interactive \
#         --rm \
#         --user $(id -u):$(id -g) \
#         --volume $(pwd):/app \
#         --volume ~/.ssh:/root/.ssh \
#         --volume ~/.config/composer:/composer \
#         --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
#         --env SSH_AUTH_SOCK=/ssh-auth.sock \
#         composer $argument
# }

# consul(){
#     images_local_build consul
#     del_stopped consul

#     # check if we passed args and if consul is running
#     local args=$@
#     local state=$(docker inspect --format "{{.State.Running}}" consul 2>/dev/null)
#     if [[ "$state" == "true" ]] && [[ ! -z "$args" ]]; then
#             docker exec -it consul consul "$@"
#             return 0
#     fi

#     docker run -d \
#         --user $(id -u):$(id -g) \
#             --restart always \
#             -v $HOME/.consul:/etc/consul.d \
#             -v /var/run/docker.sock:/var/run/docker.sock \
#             --net host \
#             -e GOMAXPROCS=2 \
#             --name consul \
#             ${DOCKER_REPO_PREFIX}consul agent \
#             -bootstrap-expect 1 \
#             -config-dir /etc/consul.d \
#             -data-dir /data \
#             -encrypt $(docker run --rm ${DOCKER_REPO_PREFIX}consul keygen) \
#             -ui-dir /usr/src/consul \
#             -server \
#             -dc neverland \
#             -bind 0.0.0.0

#     sudo hostess add consul $(docker inspect --format "{{.NetworkSettings.Networks.bridge.IPAddress}}" consul)
#     browser-exec "http://consul:8500"
# }
# cordova(){
#     images_local_build cordova

#     del_stopped cordova

#     docker run -it --rm \
#         --user $(id -u):$(id -g) \
# 		--privileged \
#                 -v /dev/bus/usb:/dev/bus/usb \
#                 -v $PWD:/src \
# 		-w /src \
# 		cordova cordova "$@"
# }
dcos(){
    images_local_build dcos-cli

    docker run -it --rm \
        --user $(id -u):$(id -g) \
            -v $HOME/.dcos:/root/.dcos \
            -v $(pwd):/root/apps \
            -w /root/apps \
            ${DOCKER_REPO_PREFIX}dcos-cli "$@"
}
dbvis(){
    images_local_build dbvis

    docker run -d -ti \
        --user $(id -u):$(id -g) \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v `pwd`:/root \
            ${DOCKER_REPO_PREFIX}dbvis
}
dia(){
    if [[ "$(pinpoint dia)" ]]; then
        command dia "$@"
        return 
    fi
    images_local_build dia

    docker run -d -ti \
        --user $(id -u):$(id -g) \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v `pwd`:/root \
            ${DOCKER_REPO_PREFIX}dia
}
# firefox(){
#     if [[ "$(pinpoint firefox)" ]]; then
#         command firefox "$@" &> /dev/null
#         return 
#     fi
#     images_local_build firefox

#     del_stopped firefox

#     # add flags for proxy if passed
#     local proxy=
#     local map=
#     local args=$@
#     if [[ "$1" == "tor" ]]; then
#         relies_on torproxy

#         map="MAP * ~NOTFOUND , EXCLUDE torproxy"
#         proxy="socks5://torproxy:9050"
#         args="https://check.torproject.org/api/ip ${@:2}"
#     fi

#     sudo docker run -d \
#         --user $(id -u):$(id -g) \
#         --memory 2gb \
#         --net host \
#         --cpuset-cpus 0 \
#         -v /etc/localtime:/etc/localtime:ro \
#         -v /tmp/.X11-unix:/tmp/.X11-unix \
#         -e DISPLAY=unix$DISPLAY \
#         -e GDK_SCALE \
#         -e GDK_DPI_SCALE \
#         -v $HOME/.firefox/cache:/root/.cache/mozilla \
#         -v $HOME/.firefox/mozilla:/root/.mozilla \
#         -v $HOME/Downloads:/root/Downloads \
#         -v $HOME/$DOTFILES_FOLDER_PICTURES:/root/Pictures \
#         -v $HOME/Torrents:/root/Torrents \
#         -v /dev/shm:/dev/shm \
#         -v /etc/hosts:/etc/hosts \
#         --device /dev/snd \
#         --device /dev/dri \
#         --device /dev/video0 \
#         --device /dev/usb \
#         --device /dev/bus/usb \
#         --group-add audio \
#         --group-add video \
#         --name firefox \
#         --proxy-server="$proxy" \
#         ${DOCKER_REPO_PREFIX}firefox "$@" &> /dev/null
# }
# gcalcli(){
#     images_local_build gcalcli

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v /etc/localtime:/etc/localtime:ro \
#             -v $HOME/.gcalcli/home:/home/gcalcli/home \
#             -v $HOME/.gcalcli/work/oauth:/home/gcalcli/.gcalcli_oauth \
#             -v $HOME/.gcalcli/work/gcalclirc:/home/gcalcli/.gcalclirc \
#             --name gcalcli \
#             ${DOCKER_REPO_PREFIX}gcalcli "$@"
# }
# gcloud(){
#     images_local_build gcloud

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v $HOME/.gcloud:/root/.config/gcloud \
#             -v $HOME/.ssh:/root/.ssh:ro \
#             --name gcloud \
#             ${DOCKER_REPO_PREFIX}gcloud "$@"
# }
gimp(){
    if [[ "$(pinpoint gimp)" ]]; then
        command gimp "$@"
        return 
    fi
    images_local_build gimp

    del_stopped gimp

    docker run -d \
        --user $(id -u):$(id -g) \
            -v /etc/localtime:/etc/localtime:ro \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -e DISPLAY=unix$DISPLAY \
            -v $HOME/$DOTFILES_FOLDER_PICTURES:/root/Pictures \
            -v $HOME/.gtkrc:/root/.gtkrc \
            -e GDK_SCALE \
            -e GDK_DPI_SCALE \
            --name gimp \
            ${DOCKER_REPO_PREFIX}gimp
}
# gitk(){
#     if [[ "$(pinpoint gitk)" ]]; then
#         command gitk "$@"
#         return 
#     fi
#     images_remote_build sierratecnologia gitk

#     docker run -d -ti \
#         --user $(id -u):$(id -g) \
#             -e DISPLAY=$DISPLAY \
#             -v /tmp/.X11-unix:/tmp/.X11-unix \
#             -v `pwd`:/var/www \
#             sierratecnologia/gitk "$@"
# }
# hollywood(){
#     if [[ "$(pinpoint hollywood)" ]]; then
#         command hollywood "$@"
#         return 
#     fi
#     images_local_build hollywood

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             --name hollywood \
#             ${DOCKER_REPO_PREFIX}hollywood
# }
htop(){
    if [[ "$(pinpoint htop)" ]]; then
        command htop "$@"
        return 
    fi
    images_local_build htop

    docker run --rm -it \
        --user $(id -u):$(id -g) \
            --pid host \
            --net none \
            --name htop \
            ${DOCKER_REPO_PREFIX}htop
}
# http(){
#     images_local_build httpie

#     docker run -t --rm \
#         --user $(id -u):$(id -g) \
#             -v /var/run/docker.sock:/var/run/docker.sock \
#             --log-driver none \
#             ${DOCKER_REPO_PREFIX}httpie "$@"
# }
# imagemin(){
#     images_local_build imagemin

#     local image=$1
#     local extension="${image##*.}"
#     local filename="${image%.*}"

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v /etc/localtime:/etc/localtime:ro \
#             -v $HOME/$DOTFILES_FOLDER_PICTURES:/root/Pictures \
#             ${DOCKER_REPO_PREFIX}imagemin sh -c "imagemin /root/Pictures/${image} > /root/Pictures/${filename}_min.${extension}"
# }
# irssi() {
#     images_local_build irssi

#     del_stopped irssi
#     # relies_on notify_osd

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v /etc/localtime:/etc/localtime:ro \
#             -v $HOME/.irssi:/home/user/.irssi \
#             --read-only \
#             --name irssi \
#             ${DOCKER_REPO_PREFIX}irssi
# }
# john(){
#     images_local_build john

#     local file=$(realpath $1)

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v ${file}:/root/$(basename ${file}) \
#             ${DOCKER_REPO_PREFIX}john $@
# }
# kernel_builder(){
#     images_local_build kernel-builder

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v /usr/src:/usr/src \
#             --cpu-shares=512 \
#             --name kernel-builder \
#             ${DOCKER_REPO_PREFIX}kernel-builder
# }
# kicad(){
# 	images_local_build kicad 4.0
#   docker run --rm -it \
#         --user $(id -u):$(id -g) \
# 		  -e DISPLAY=$DISPLAY \
# 			-v /tmp/.X11-unix:/tmp/.X11-unix \
# 			${DOCKER_REPO_PREFIX}kicad:4.0
# }
# kvm(){
#     images_local_build kvm

#     del_stopped kvm
#     relies_on pulseaudio

#     # modprobe the module
#     sudo modprobe kvm

#     docker run -d \
#         --user $(id -u):$(id -g) \
#             -v /etc/localtime:/etc/localtime:ro \
#             -v /tmp/.X11-unix:/tmp/.X11-unix \
#             -v /run/libvirt:/var/run/libvirt \
#             -e DISPLAY=unix$DISPLAY \
#             --link pulseaudio:pulseaudio \
#             -e PULSE_SERVER=pulseaudio \
#             --group-add audio \
#             --name kvm \
#             --privileged \
#             ${DOCKER_REPO_PREFIX}kvm
# }
# libreoffice(){
#     if [[ "$(pinpoint libreoffice)" ]]; then
#         command libreoffice "$@"
#         return 
#     fi
#     images_local_build libreoffice

#     del_stopped libreoffice

#     docker run -d \
#         --user $(id -u):$(id -g) \
#             -v /etc/localtime:/etc/localtime:ro \
#             -v /tmp/.X11-unix:/tmp/.X11-unix \
#             -e DISPLAY=unix$DISPLAY \
#             -v $HOME/slides:/root/slides \
#             -e GDK_SCALE \
#             -e GDK_DPI_SCALE \
#             --name libreoffice \
#             ${DOCKER_REPO_PREFIX}libreoffice
# }
# lpass(){
#     images_local_build lpass

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             -v $HOME/.lpass:/root/.lpass \
#             --name lpass \
#             ${DOCKER_REPO_PREFIX}lpass "$@"
# }
# lynx(){
#     images_local_build lynx

#     docker run --rm -it \
#         --user $(id -u):$(id -g) \
#             --name lynx \
#             ${DOCKER_REPO_PREFIX}lynx "$@"
# }
# masscan(){
#     if [[ "$(pinpoint masscan)" ]]; then
#         command masscan "$@"
#         return 
#     fi
#     images_local_build masscan

#     docker run -it --rm \
#         --user $(id -u):$(id -g) \
#             --log-driver none \
#             --net host \
#             --cap-add NET_ADMIN \
#             --name masscan \
#             ${DOCKER_REPO_PREFIX}masscan "$@"
# }
maltego(){
    if [[ "$(pinpoint maltego)" ]]; then
        command maltego "$@"
        return 
    fi
    images_remote_build sierratecnologia maltego
    docker run -d -ti \
        --user $(id -u):$(id -g) \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            sierratecnologia/maltego "$@"
}
# mpd(){
#   images_local_build mpd

# 	del_stopped mpd

# 	# adding cap sys_admin so I can use nfs mount
# 	# the container runs as a unpriviledged user mpd
# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		--device /dev/snd \
# 		--cap-add SYS_ADMIN \
# 		-e MPD_HOST=/var/lib/mpd/socket \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /etc/exports:/etc/exports:ro \
# 		-v $HOME/.mpd:/var/lib/mpd \
# 		-v $HOME/.mpd.conf:/etc/mpd.conf \
# 		--name mpd \
# 		${DOCKER_REPO_PREFIX}mpd
# }
mysql-workbench(){
    if [[ "$(pinpoint mysql-workbench)" ]]; then
        command mysql-workbench "$@"
        return 
    fi
  images_local_build raphabot mysql-workbench

	sudo docker run -ti --rm \
                --user $(id -u):$(id -g) \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v `pwd`:/root \
		raphabot/mysql-workbench
}
# mutt(){
#   images_local_build mutt

# 	# subshell so we dont overwrite variables
# 	(
# 	local account=$1
# 	export IMAP_SERVER=""
# 	export SMTP_SERVER=""

# 	if [[ "$account" == "riseup" ]]; then
# 		GMAIL=$MAIL_RISEUP
# 		GMAIL_NAME=$MAIL_RISEUP_NAME
# 		GMAIL_PASS=$MAIL_RISEUP_PASS
# 		GMAIL_FROM=$MAIL_RISEUP_FROM
# 		IMAP_SERVER=mail.riseup.net
# 		SMTP_SERVER=$IMAP_SERVER
# 	fi

# 	docker run -it --rm \
#                 --user $(id -u):$(id -g) \
# 		-e GMAIL \
# 		-e GMAIL_NAME \
# 		-e GMAIL_PASS \
# 		-e GMAIL_FROM \
# 		-e GPG_ID \
# 		-e IMAP_SERVER \
# 		-e SMTP_SERVER \
# 		-v $HOME/.gnupg:/home/user/.gnupg:ro \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		--name mutt${account} \
# 		${DOCKER_REPO_PREFIX}mutt
# 	)
# }
# ncmpc(){
#   images_local_build ncmpc

# 	del_stopped ncmpc

# 	docker run --rm -it \
#                 --user $(id -u):$(id -g) \
# 		-v $HOME/.mpd/socket:/var/run/mpd/socket \
# 		-e MPD_HOST=/var/run/mpd/socket \
# 		--name ncmpc \
# 		${DOCKER_REPO_PREFIX}ncmpc "$@"
# }
# neoman(){
#   images_local_build neoman

# 	del_stopped neoman

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-e DISPLAY=unix$DISPLAY \
# 		--device /dev/bus/usb \
# 		--device /dev/usb \
# 		--name neoman \
# 		${DOCKER_REPO_PREFIX}neoman
# }
# nes(){
#   images_local_build nes

# 	del_stopped nes
# 	local game=$1

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-e DISPLAY=unix$DISPLAY \
# 		--device /dev/dri \
# 		--device /dev/snd \
# 		--name nes \
# 		${DOCKER_REPO_PREFIX}nes /games/${game}.rom
# }
alias nb=netbeans
netbeans(){
    images_remote_build sierratecnologia netbeans
    docker run -ti --rm \
        --user $(id -u):$(id -g) \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v `pwd`:/home/developer \
            sierratecnologia/netbeans
}
alias nb-php=netbeans_php
alias netbeans-php=netbeans_php
netbeans_php(){
    images_remote_build sierratecnologia netbeans-php
	docker run -ti --rm \
                --user $(id -u):$(id -g) \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v `pwd`:/home/developer \
		--name netbeans-php \
		sierratecnologia/netbeans-php
}
netcat(){
    if [[ "$(pinpoint netcat)" ]]; then
        command netcat "$@"
        return 
    fi
  images_local_build netcat

  docker run --rm -it \
      --user $(id -u):$(id -g) \
      --net host \
      ${DOCKER_REPO_PREFIX}netcat "$@"
}
nginx(){
	del_stopped nginx

	docker run -d \
                --user $(id -u):$(id -g) \
		--restart always \
		-v $HOME/.nginx:/etc/nginx \
		--net host \
		--name nginx \
		nginx

	# add domain to hosts & open nginx
	sudo hostess add sierra 127.0.0.1
}
nmap(){
    if [[ "$(pinpoint nmap)" ]]; then
        command nmap "$@"
        return 
    fi

    images_local_build nmap

    docker run --rm -it \
            --user $(id -u):$(id -g) \
            --net host \
            ${DOCKER_REPO_PREFIX}nmap "$@"
}
notify_osd(){
  images_local_build notify-osd

	del_stopped notify_osd

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		--net none \
		-v /etc \
		-v /home/user/.dbus \
		-v /home/user/.cache/dconf \
		-e DISPLAY=unix$DISPLAY \
		--name notify_osd \
		${DOCKER_REPO_PREFIX}notify-osd
}
alias notify-send=notify_send
notify_send(){
	relies_on notify_osd
	local args=${@:2}

	docker exec --user $(id -u):$(id -g) -i notify_osd notify-send "$1" "${args}"
}
# pandoc(){
#     if [[ "$(pinpoint pandoc)" ]]; then
#         command pandoc "$@"
#         return 
#     fi
#   images_local_build pandoc

# 	local file=${@: -1}
# 	local lfile=$(readlink -m "$(pwd)/${file}")
# 	local rfile=$(readlink -m "/$(basename $file)")
# 	local args=${@:1:${#@}-1}

# 	docker run --rm \
#                 --user $(id -u):$(id -g) \
# 		-v ${lfile}:${rfile} \
# 		-v /tmp:/tmp \
# 		--name pandoc \
# 		${DOCKER_REPO_PREFIX}pandoc ${args} ${rfile}
# }
# alias php=php_cli
php_cli(){
    if [[ "$(pinpoint php)" ]]; then
        command php "$@"
        return 
    fi
    images_remote_build sierratecnologia php:7.4

    del_stopped php-cli  

    # Caso Seja interativo
    EXTRA_ARGS=''
    for ARG in "$@"
    do
        if [[ "$ARG" == "-a" ]]; then
            EXTRA_ARGS=' -it'
        fi
    done

    echo "${EXTRA_ARGS}"
    echo "docker run --rm ${EXTRA_ARGS}--user $(id -u):$(id -g) --name=php-cli -v $(pwd):/var/www/html sierratecnologia/php:7.0 php "$@""
    docker run --rm${EXTRA_ARGS} --user $(id -u):$(id -g) --name=php-cli -v $(pwd):/var/www/html sierratecnologia/php:7.0 php "$@"
}
phpmyadmin(){
  del_stopped phpmyadmin

  dfazer
}
phonegap(){
  images_local_build phonegap 3.6.0-0-21-19

  del_stopped phonegap

  docker run -it --rm \
    --user $(id -u):$(id -g) \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $PWD:/data \
    -w /data \
    phonegap "$@"
}
# pivman(){
#   images_local_build pivman

# 	del_stopped pivman

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-e DISPLAY=unix$DISPLAY \
# 		--device /dev/bus/usb \
# 		--device /dev/usb \
# 		--name pivman \
# 		${DOCKER_REPO_PREFIX}pivman
# }
# pms(){
#   images_local_build pms

# 	del_stopped pms

# 	docker run --rm -it \
#                 --user $(id -u):$(id -g) \
# 		-v $HOME/.mpd/socket:/var/run/mpd/socket \
# 		-e MPD_HOST=/var/run/mpd/socket \
# 		--name pms \
# 		${DOCKER_REPO_PREFIX}pms "$@"
# }
# pond(){
#   images_local_build pond

# 	del_stopped pond
# 	relies_on torproxy

# 	docker run --rm -it \
#                 --user $(id -u):$(id -g) \
# 		--net container:torproxy \
# 		--name pond \
# 		${DOCKER_REPO_PREFIX}pond
# }
# privoxy(){
#   images_local_build privoxy

# 	del_stopped privoxy
# 	relies_on torproxy

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		--restart always \
# 		--link torproxy:torproxy \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-p 8118:8118 \
# 		--name privoxy \
# 		${DOCKER_REPO_PREFIX}privoxy

# 	sudo hostess add privoxy $(docker inspect --format "{{.NetworkSettings.Networks.bridge.IPAddress}}" privoxy)
# }
pulseaudio(){
  images_local_build pulseaudio

	del_stopped pulseaudio

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		--device /dev/snd \
		-p 4713:4713 \
		--restart always \
		--group-add audio \
		--name pulseaudio \
		${DOCKER_REPO_PREFIX}pulseaudio
}
# rainbowstream(){
#   images_local_build rainbowstream

# 	docker run -it --rm \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v $HOME/.rainbow_oauth:/root/.rainbow_oauth \
# 		-v $HOME/.rainbow_config.json:/root/.rainbow_config.json \
# 		--name rainbowstream \
# 		${DOCKER_REPO_PREFIX}rainbowstream
# }
# registrator(){
# 	del_stopped registrator

# 	docker run -d --restart always \
#                 --user $(id -u):$(id -g) \
# 		-v /var/run/docker.sock:/tmp/docker.sock \
# 		--net host \
# 		--name registrator \
# 		gliderlabs/registrator consul:
# }
# remmina(){
#   images_local_build remmina

# 	del_stopped remmina

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-e DISPLAY=unix$DISPLAY \
# 		-e GDK_SCALE \
# 		-e GDK_DPI_SCALE \
# 		-v $HOME/.remmina:/root/.remmina \
# 		--name remmina \
# 		--net host \
# 		${DOCKER_REPO_PREFIX}remmina
# }
# ricochet(){
#   images_local_build ricochet

# 	del_stopped ricochet

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-e DISPLAY=unix$DISPLAY \
# 		-e GDK_SCALE \
# 		-e GDK_DPI_SCALE \
# 		-e QT_DEVICE_PIXEL_RATIO \
# 		--device /dev/dri \
# 		--name ricochet \
# 		${DOCKER_REPO_PREFIX}ricochet
# }
# rstudio(){
#   images_local_build rstudio

# 	del_stopped rstudio

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-v $HOME/fastly-logs:/root/fastly-logs \
# 		-v /dev/shm:/dev/shm \
# 		-e DISPLAY=unix$DISPLAY \
# 		-e QT_DEVICE_PIXEL_RATIO \
# 		--device /dev/dri \
# 		--name rstudio \
# 		${DOCKER_REPO_PREFIX}rstudio
# }
# s3cmdocker(){
#   images_local_build s3cmd

# 	del_stopped s3cmd

# 	docker run --rm -it \
#                 --user $(id -u):$(id -g) \
# 		-e AWS_ACCESS_KEY="${DOCKER_AWS_ACCESS_KEY}" \
# 		-e AWS_SECRET_KEY="${DOCKER_AWS_ACCESS_SECRET}" \
# 		-v $(pwd):/root/s3cmd-workspace \
# 		--name s3cmd \
# 		${DOCKER_REPO_PREFIX}s3cmd "$@"
# }
scilab(){
    images_remote_build sierratecnologia scilab
    docker run -d -ti \
            --user $(id -u):$(id -g) \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            sierratecnologia/scilab "$@"
}
# scudcloud(){
#   images_local_build scudcloud

# 	del_stopped scudcloud

# 	docker run -d \
#                 --user $(id -u):$(id -g) \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		-e DISPLAY=unix$DISPLAY \
# 		-v /etc/machine-id:/etc/machine-id:ro \
# 		-v /var/run/dbus:/var/run/dbus \
# 		-v /var/run/user/$(id -u):/var/run/user/$(id -u) \
# 		-e TERM \
# 		-e XAUTHORITY \
# 		-e DBUS_SESSION_BUS_ADDRESS \
# 		-e HOME \
# 		-e QT_DEVICE_PIXEL_RATIO \
# 		-v /etc/passwd:/etc/passwd:ro \
# 		-v /etc/group:/etc/group:ro \
# 		-u $(whoami) -w "$HOME" \
# 		-v $HOME/.Xauthority:$HOME/.Xauthority \
# 		-v /etc/machine-id:/etc/machine-id:ro \
# 		-v $HOME/.scudcloud:/home/jessie/.config/scudcloud \
# 		--device /dev/snd \
# 		--name scudcloud \
# 		${DOCKER_REPO_PREFIX}scudcloud

# 	# exit current shell
# 	exit 0
# }
# shorewall(){
#   images_local_build shorewall

# 	del_stopped shorewall

# 	docker run --rm -it \
#                 --user $(id -u):$(id -g) \
# 		--net host \
# 		--cap-add NET_ADMIN \
# 		--privileged \
# 		--name shorewall \
# 		${DOCKER_REPO_PREFIX}shorewall "$@"
# }
skype(){
    if [[ "$(pinpoint skype)" ]]; then
        command skype "$@"
        return 
    fi
  images_local_build skype

	del_stopped skype
	relies_on pulseaudio

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		--security-opt seccomp:unconfined \
		--device /dev/video0 \
		--group-add video \
		--link pulseaudio:pulseaudio \
		-e PULSE_SERVER=pulseaudio \
		--group-add audio \
		--name skype \
		${DOCKER_REPO_PREFIX}skype
}
slack(){
    if [[ "$(pinpoint slack)" ]]; then
        command slack "$@"
        return 
    fi
  images_local_build slack

	del_stopped slack
	relies_on pulseaudio

	sudo docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		--device /dev/snd \
		--device /dev/dri \
		--device /dev/video0 \
		--link pulseaudio:pulseaudio \
		-e PULSE_SERVER=pulseaudio \
		--group-add audio \
		--group-add video \
		-v /home/jessie/.slack:/root/.config/Slack \
		--name slack \
		${DOCKER_REPO_PREFIX}slack "$@"
}
spotify(){
    if [[ "$(pinpoint spotify)" ]]; then
        command spotify "$@"
        return 
    fi
    images_local_build spotify

    del_stopped spotify

    docker run -d \
        --user $(id -u):$(id -g) \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=unix$DISPLAY \
        -e QT_DEVICE_PIXEL_RATIO \
        --security-opt seccomp:unconfined \
        --device /dev/snd \
        --device /dev/dri \
        --group-add audio \
        --group-add video \
        --name spotify \
        ${DOCKER_REPO_PREFIX}spotify
}

alias s=sublime-text-3
alias subl=sublime-text-3
alias subl=sublime-text-3
alias sublime=sublime-text-3
sublime-text-3(){
    if [[ "$(pinpoint sublime-text-3)" ]]; then
        command sublime-text-3 "$@"
        return 
    fi

		if [[ "$(pinpoint subl)" ]]; then
			  command subl "$@"
				return
		fi

    images_local_build sublime-text-3

    docker run -d -ti \
            --user $(id -u):$(id -g) \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $HOME/.config/sublime-text-3/:/root/.config/sublime-text-3 \
            -v $HOME/$DOTFILES_FOLDER_PROJECTS:/root/development \
            -v `pwd`:/root/www \
            -v /var/run/dbus:/var/run/dbus \
            ${DOCKER_REPO_PREFIX}sublime-text-3 "$@"
}
ssh2john(){
  images_local_build john

	local file=$(realpath $1)

	docker run --rm -it \
                --user $(id -u):$(id -g) \
		-v ${file}:/root/$(basename ${file}) \
		--entrypoint ssh2john \
		${DOCKER_REPO_PREFIX}john $@
}

steam(){
    if [[ "$(pinpoint steam)" ]]; then
        command steam "$@"
        return 
    fi
    images_local_build steam

    del_stopped steam
    relies_on pulseaudio

    docker run -d \
            --user $(id -u):$(id -g) \
            -v /etc/localtime:/etc/localtime:ro \
            -v /etc/machine-id:/etc/machine-id:ro \
            -v /var/run/dbus:/var/run/dbus \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $HOME/.steam:/home/steam \
            -e DISPLAY=unix$DISPLAY \
            --link pulseaudio:pulseaudio \
            -e PULSE_SERVER=pulseaudio \
            --device /dev/dri \
            --name steam \
            ${DOCKER_REPO_PREFIX}steam
}
t(){
    images_local_build t

    docker run -t --rm \
            --user $(id -u):$(id -g) \
            -v $HOME/.trc:/root/.trc \
            --log-driver none \
            ${DOCKER_REPO_PREFIX}t "$@"
}
tarsnap(){
    images_local_build tarsnap

    docker run --rm -it \
            --user $(id -u):$(id -g) \
            -v $HOME/.tarsnaprc:/root/.tarsnaprc \
            -v $HOME/.tarsnap:/root/.tarsnap \
            -v $HOME:/root/workdir \
            ${DOCKER_REPO_PREFIX}tarsnap "$@"
}
telnet(){
    if [[ "$(pinpoint telnet)" ]]; then
        command telnet "$@"
        return 
    fi
    images_local_build telnet

    docker run -it --rm \
        --user $(id -u):$(id -g) \
        --log-driver none \
        ${DOCKER_REPO_PREFIX}telnet "$@"
}
termboy(){
  images_local_build termboy

	del_stopped termboy
	local game=$1

	docker run --rm -it \
                --user $(id -u):$(id -g) \
		--device /dev/snd \
		--name termboy \
		${DOCKER_REPO_PREFIX}nes /games/${game}.rom
}

thunderbird(){
  images_local_build thunderbird

	docker run -ti --rm \
                --user $(id -u):$(id -g) \
		-e DISPLAY=$DISPLAY \
		--net host \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $HOME/.thunderbird:/root/.thunderbird
		-v $HOME/.cache/.thunderbird:/root/.cache/thunderbird
		-v `pwd`:/var/www \
		${DOCKER_REPO_PREFIX}thunderbird
}
tor(){

	del_stopped tor

	docker run -d \
                --user $(id -u):$(id -g) \
		--net host \
		--name tor \
		jess/tor

	# set up the redirect iptables rules
	sudo setup-tor-iptables

	# validate we are running through tor
	browser-exec "https://check.torproject.org/"
}
torbrowser(){

	del_stopped torbrowser

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		-e GDK_SCALE \
		-e GDK_DPI_SCALE \
		--device /dev/snd \
		--name torbrowser \
		${DOCKER_REPO_PREFIX}tor-browser

	# exit current shell
	exit 0
}
tormessenger(){
  images_local_build tor-messenger

	del_stopped tormessenger

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		-e GDK_SCALE \
		-e GDK_DPI_SCALE \
		--device /dev/snd \
		--name tormessenger \
		${DOCKER_REPO_PREFIX}tor-messenger

	# exit current shell
	exit 0
}
torproxy(){
  images_local_build tor-proxy

	del_stopped torproxy

	docker run -d \
                --user $(id -u):$(id -g) \
		--restart always \
		-v /etc/localtime:/etc/localtime:ro \
		-p 9050:9050 \
		--name torproxy \
		${DOCKER_REPO_PREFIX}tor-proxy

	sudo hostess add torproxy $(docker inspect --format "{{.NetworkSettings.Networks.bridge.IPAddress}}" torproxy)
}
traceroute(){
  images_local_build traceroute

	docker run --rm -it \
                --user $(id -u):$(id -g) \
		--net host \
		${DOCKER_REPO_PREFIX}traceroute "$@"
}
transmission(){
  images_local_build transmission

	del_stopped transmission

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v $HOME/Torrents:/transmission/download \
		-v $HOME/.transmission:/transmission/config \
		-p 9091:9091 \
		-p 51413:51413 \
		-p 51413:51413/udp \
		--name transmission \
		${DOCKER_REPO_PREFIX}transmission


	sudo hostess add transmission $(docker inspect --format "{{.NetworkSettings.Networks.bridge.IPAddress}}" transmission)
	browser-exec "http://transmission:9091"
}
virsh(){
  images_local_build libvirt-client

	relies_on kvm

	docker run -it --rm \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /run/libvirt:/var/run/libvirt \
		--log-driver none \
		--net container:kvm \
		${DOCKER_REPO_PREFIX}libvirt-client "$@"
}
alias virt-viewer="virt_viewer"
virt_viewer(){
  images_local_build virt-viewer

	relies_on kvm

	docker run -it --rm \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix  \
		-e DISPLAY=unix$DISPLAY \
		-v /run/libvirt:/var/run/libvirt \
		-e PULSE_SERVER=pulseaudio \
		--group-add audio \
		--log-driver none \
		--net container:kvm \
		${DOCKER_REPO_PREFIX}virt-viewer "$@"
}
visualstudio(){
  images_local_build visualstudio

	del_stopped visualstudio

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix  \
		-e DISPLAY=unix$DISPLAY \
		--name visualstudio \
		${DOCKER_REPO_PREFIX}visualstudio
}
vlc(){
  images_local_build vlc

	del_stopped vlc
	relies_on pulseaudio

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		-e GDK_SCALE \
		-e GDK_DPI_SCALE \
		-e QT_DEVICE_PIXEL_RATIO \
		--link pulseaudio:pulseaudio \
		-e PULSE_SERVER=pulseaudio \
		--group-add audio \
		--group-add video \
		-v $HOME/Torrents:/home/vlc/Torrents \
		--device /dev/dri \
		--name vlc \
		${DOCKER_REPO_PREFIX}vlc
}
warzone2100(){
  images_local_build warzone2100

	docker run -ti --rm \
                --user $(id -u):$(id -g) \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v `pwd`:/home/.warzone2100-3.1 \
		${DOCKER_REPO_PREFIX}warzone2100
}
watchman(){
  images_local_build watchman

	del_stopped watchman

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v $HOME/Downloads:/root/Downloads \
		--name watchman \
		${DOCKER_REPO_PREFIX}watchman --foreground
}
wireshark(){
  images_local_build wireshark

	del_stopped wireshark

	docker run -d \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		--net host \
		--name wireshark \
		${DOCKER_REPO_PREFIX}wireshark
}
wrk(){
  images_local_build wrk

	docker run -it --rm \
                --user $(id -u):$(id -g) \
		--log-driver none \
		--name wrk \
		${DOCKER_REPO_PREFIX}wrk "$@"
}
ykpersonalize(){
  images_local_build ykpersonalize

	del_stopped ykpersonalize

	docker run --rm -it \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		--device /dev/usb \
		--device /dev/bus/usb \
		--name ykpersonalize \
		${DOCKER_REPO_PREFIX}ykpersonalize bash
}
alias yubico-piv-tool="yubico_piv_tool"
yubico_piv_tool(){
  images_local_build yubico-piv-tool

	del_stopped yubico-piv-tool

	docker run --rm -it \
                --user $(id -u):$(id -g) \
		-v /etc/localtime:/etc/localtime:ro \
		--device /dev/usb \
		--device /dev/bus/usb \
		--name yubico-piv-tool \
		${DOCKER_REPO_PREFIX}yubico-piv-tool bash
}


# ###
# ### Awesome sauce by @jpetazzo
# ###
# command_not_found_handle () {
#   #images_local_build $@
#
# 	# Check if there is a container image with that name
# 	if ! docker inspect --format '{{ .Author }}' "$1" >&/dev/null ; then
# 		echo "$0: $1: command not found"
# 		return
# 	fi
#
# 	# Check that it's really the name of the image, not a prefix
# 	if docker inspect --format '{{ .Id }}' "$1" | grep -q "^$1" ; then
# 		echo "$0: $1: command not found"
# 		return
# 	fi
#
# 	docker run -ti -u $(whoami) -w "$HOME" \
# 		$(env | cut -d= -f1 | awk '{print "-e", $1}') \
# 		--device /dev/snd \
# 		-v /etc/passwd:/etc/passwd:ro \
# 		-v /etc/group:/etc/group:ro \
# 		-v /etc/localtime:/etc/localtime:ro \
# 		-v /home:/home \
# 		-v /tmp/.X11-unix:/tmp/.X11-unix \
# 		"${DOCKER_REPO_PREFIX}$@"
# }
