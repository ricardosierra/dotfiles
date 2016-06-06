
# Install Docker in Ubuntu
if (is_ubuntu); then
  if [[ ! "$(type -P docker)" ]]; then
    e_header "Installing Docker"
    (
      sudo apt-get -qq install docker.io -y
    )
  fi
  if [[ ! "$(type -P docker-compose)" ]]; then
    e_header "Installing Docker-Compose"
    (
      sudo curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
    )
  fi
fi

# Install Docker in Mac
if (is_osx); then
  e_header "Installing Docker"
  (
    brew install docker
    brew install boot2docker
  )
  e_header "Installing Docker-Compose"
  (
    brew install docker-compose
  )
fi
