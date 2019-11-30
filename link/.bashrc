
#echo 'Loading bashrc...'

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

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# Load Bash RC Common Source
source $HOME/.commonrc

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#	sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#
#I comment this because this cause one erro:
# have: comando não encontrado
# ++++++++++ return 127
# ++++++++++ unset __grub_install_program
# ++++++++++ __grub_mkfont_program=grub-mkfont
# ++++++++++ have grub-mkfont
# ++++++++++ '[' -x /usr/lib/command-not-found ']'
# ++++++++++ /usr/lib/command-not-found -- have
# Comando 'have' não encontrado, você quis dizer:
#  Comando 'dave' do pacote 'libhttp-dav-perl' (universe)
#  Comando 'havp' do pacote 'havp' (universe)
#  Comando 'haxe' do pacote 'haxe' (universe)
#  Comando 'save' do pacote 'atfs' (universe)
# have: comando não encontrado
#
# if ! shopt -oq posix; then
# 	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
# 		. /usr/share/bash-completion/bash_completion
# 	elif [[ -f /etc/bash_completion ]]; then
# 		. /etc/bash_completion
# 	fi
# fi
# for file in /etc/bash_completion.d/* ; do
# 	source "$file"
# done
#END THIS


src

# Load the shell dotfiles, and then some:
# * ~/.aliases can be created aliases.
# * ~/.exports can be used to create exports.
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{aliases,exports,path}; do
	[[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done

# Load the shell complete
for file in ~/.completion/.*[^~]; do
	[[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done

if [[ ! "$TMUX" ]]; then
	tmux
fi

clear

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
