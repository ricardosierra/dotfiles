# Install Docker in Ubuntu
if (is_ubuntu); then
  if [[ ! "$(type -P docker)" ]]; then
    e_header "Installing Docker"
    (
      sudo apt-get -qq install docker.io -y
      sudo usermod -aG docker $USER
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
fi
