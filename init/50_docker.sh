#!/bin/bash

install_docker() {
    install_docker_linux() {
        sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

        user=$(whoami)
        if (is_ubuntu); then
            install_docker_linux_ubuntu_package
        elif (is_debianOS); then
            install_docker_linux_debian_package
            sudo apt-get update
            apt-cache policy docker-engine
            sudo apt-get install -y docker-engine
            sudo service docker start
        else
            return
        fi

        sudo groupadd docker
        sudo usermod -aG docker $user
        sudo systemctl enable docker
        #sudo upstart enable docker
    }

    install_docker_linux_ubuntu_package() {
        sudo apt-get update
        sudo apt-get install \
            linux-image-extra-$(uname -r) \
            linux-image-extra-virtual
        sudo apt-get update
        sudo apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
           $(lsb_release -cs) \
           stable"
       sudo apt-get update
       sudo apt-get install docker-ce
    }

    install_docker_linux_debian_package() {
        release=$(lsb_release -r)
        version=$(cut -d ':' -f 2 <<< $release | xargs)
        if [ $version == '7.0' ]; then
            package="deb https://apt.dockerproject.org/repo debian-wheezy main"
        elif [ $version == '8.0' ]; then
            package="deb https://apt.dockerproject.org/repo debian-jessie main"
        elif [ $version == '9.0' ]; then
            package="deb https://apt.dockerproject.org/repo debian-stretch main"
        else
            return
        fi
        echo "$package" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    }

    install_docker_windows() {
        URL="https://docs.docker.com/engine/installation/windows/"
        path=$(which xdg-open || which gnome-open)
        $path "$URL"
    }

    install_docker_mac() {
        URL="https://docs.docker.com/engine/installation/mac/"
        path=$(which xdg-open || which gnome-open)
        $path "$URL"
    }

    e_header "Installing Docker"
    if (is_osx); then
        install_docker_mac
    # elif (is_windows); then
    #     install_docker_windows
    else
        install_docker_linux
    fi
}

# Install Docker
if [[ ! "$(pinpoint docker)" ]]; then
  install_docker
fi
