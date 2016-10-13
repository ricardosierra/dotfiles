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


# Add Identify SSH
eval `ssh-agent -s`
ssh-add  >/dev/null 2>/dev/null
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
#for file in ~/.{aliases,bash_prompt,dotfilesconfig.local,dockerfunc,exports,functions,git.completion.bash,path}; do
#	[[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
#done
#unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
	-o "nospace" \
	-W "$(grep "^Host" ~/.ssh/config | \
	grep -v "[?*]" | cut -d " " -f2 | \
	tr ' ' '\n')" scp sftp ssh


if [ -n "$PS1" ] ; then                       # are we interactive?
   [ -r ~/.bashrc     ] && . ~/.bashrc        # tty/prompt/function setup for interactive shells
   [ -r ~/.bash_login ] && . ~/.bash_login    # any at-login tasks for login shell only
fi  
