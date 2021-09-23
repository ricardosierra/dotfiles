# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Esse arquivo é executado uma vez sempre que o usuário fizer login na maquina.
# O arquivo bash_profile faz a mesama coisa quando o login é via terminal, ou
# ssh
# O bashrc é executado a cada nova janela de terminal
#/bin/bash
#       The bash executable
#/etc/profile
#       The systemwide initialization file, executed for login shells
#~/.bash_profile
#       The personal initialization file, executed for login shells
#~/.bashrc
#       The individual per-interactive-shell startup file
#~/.bash_logout
#       The individual login shell cleanup file, executed when a login shell exits
#~/.inputrc
#       Individual readline initialization file

echo 'Loading profile...'


if [ -n "$PS1" ] ; then                       # are we interactive?


    # if running bash
    if [ -n "$ZSH_VERSION" ]; then
        # include .zshrc if it exists
        if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
        fi
    elif [ -n "$BASH_VERSION" ]; then
        # include .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
        fi
    fi

    #    [ -r ~/.bashrc     ] && . ~/.bashrc        # tty/prompt/function setup for interactive shells
   [ -r ~/.bash_login ] && . ~/.bash_login    # any at-login tasks for login shell only
fi  

export PATH="/home/sierra/.local/share/solana/install/active_release/bin:$PATH"
export PATH="/home/sierra/.asdf/installs/python/3.9.6/lib/python3.9/site-packages:$PATH"
