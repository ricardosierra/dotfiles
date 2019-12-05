#!/bin/bash

# Make vim the default editor
#export EDITOR=/usr/bin/nvim;
#export TERMINAL="urxvt"; #Essa Linha está quebrando o vim

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Highlight section titles in manual pages
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";

export DBUS_SESSION_BUS_ADDRESS=unix:path=/var/run/user/$(id -u)/bus;

export TODOTXT_DEFAULT_ACTION=ls

# hidpi for gtk apps
if [[ "$OSTYPE" =~ ^darwin ]]; then
	export GDK_SCALE=2
	export GDK_DPI_SCALE=0.5
	export QT_DEVICE_PIXEL_RATIO=2
else
	export GDK_SCALE=1
	export GDK_DPI_SCALE=1
	export QT_DEVICE_PIXEL_RATIO=1
fi

# turn on go vendoring experiment
export GO15VENDOREXPERIMENT=1

# Desable docker notary TRUST because this cause one erro in docker-compose
export DOCKER_CONTENT_TRUST=0



# Importante para os paths
# PROGRAMS VARIABLES
export ANDROID_HOME="/home/$USER/$DOTFILES_FOLDER_PROGRAMS/android-sdk-linux"
export ANDROID_PLATFORM_TOOLS="/home/$USER/$DOTFILES_FOLDER_PROGRAMS/android-sdk-linux/platform-tools/"
# go path
export GOPATH=$HOME/.go