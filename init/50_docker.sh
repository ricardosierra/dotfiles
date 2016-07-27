
install_docker() {
    install_docker_linux() {
        sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D $SAIDA

        if (is_ubuntu); then
            install_docker_linux_ubuntu_package
        elif (is_debian); then
            install_docker_linux_debian_package
        elif (is_ubuntu); then
            install_docker_ubuntu
        else
            install_docker_ubuntu
        fi

        user=$(whoami)
        sudo apt-get update $SAIDA
        apt-cache policy docker-engine $SAIDA
        sudo apt-get install -y docker-engine $SAIDA
        sudo service docker start $SAIDA
        sudo sudo groupadd docker $SAIDA
        sudo usermod -aG docker $user $SAIDA
        sudo systemctl enable docker
        #sudo upstart enable docker
    }

    install_docker_linux_ubuntu_package() {
        release=$(lsb_release -r)
        version=$(cut -d ':' -f 2 <<< $release | xargs)
        if [ $version == '14.04' ]; then
            package="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
        elif [ $version == '15.10' ]; then
            package="deb https://apt.dockerproject.org/repo ubuntu-wily main"
        elif [ $version == '16.04' ]; then
            package="deb https://apt.dockerproject.org/repo ubuntu-xenial main"
        fi
        sudo echo $package > /etc/apt/sources.list.d/docker.list
    }

    install_docker_linux_debian_package() {
        release=$(lsb_release -r)
        version=$(cut -d ':' -f 2 <<< $release | xargs)
        if [ $version == '7.0' ]; then
            package="deb https://apt.dockerproject.org/repo debian-wheezy mainn"
        elif [ $version == '8.0' ]; then
            package="deb https://apt.dockerproject.org/repo debian-jessie main"
        elif [ $version == '9.0' ]; then
            package="deb https://apt.dockerproject.org/repo debian-stretch main"
        fi
        sudo echo $package > /etc/apt/sources.list.d/docker.list
    }

    install_docker_ubuntu() {
        sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D $SAIDA
        release=$(lsb_release -r)
        version=$(cut -d ':' -f 2 <<< $release | xargs)
        if [ $version == '14.04' ]; then
            package="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
        elif [ $version == '15.10' ]; then
            package="deb https://apt.dockerproject.org/repo ubuntu-wily main"
        elif [ $version == '16.04' ]; then
            package="deb https://apt.dockerproject.org/repo ubuntu-xenial main"
        fi

        user=$(whoami)

        sudo echo $package > /etc/apt/sources.list.d/docker.list
        sudo apt-get update $SAIDA
        apt-cache policy docker-engine $SAIDA
        sudo apt-get install -y docker-engine $SAIDA
        sudo service docker start $SAIDA
        sudo sudo groupadd docker $SAIDA
        sudo usermod -aG docker $user $SAIDA
        sudo systemctl enable docker
        #sudo upstart enable docker
    }

    install_docker_windows() {
        URL="https://docs.docker.com/engine/installation/windows/"
        path=$(which xdg-open || which gnome-open)
        $path $URL $SAIDA
    }

    install_docker_mac() {
        URL="https://docs.docker.com/engine/installation/mac/"
        path=$(which xdg-open || which gnome-open)
        $path $URL $SAIDA
    }

    printf "Instalando o Docker.\n"
    if (is_osx); then
        install_docker_mac
    elif (is_windows); then
        install_docker_windows
    else
        install_docker_linux
    fi
}



install_docker
