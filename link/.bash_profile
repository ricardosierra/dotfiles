if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
cowsay "Bash já executado as $(date '+%A, %d de %B de %Y às %T')"
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you donâ€™t want to commit.
for file in ~/.{bash_prompt,aliases,functions,dotfilesconfig.local,path,dockerfunc,exports}; do
    echo $file
    cowsay "${file} já executado as $(date '+%A, %d de %B de %Y às %T')"
	[[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

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

# print a fortune when the terminal opens
#fortune -a -s | lolcat

###-tns-completion-start-###
if [ -f /home/sierra/.tnsrc ]; then
    source /home/sierra/.tnsrc
fi
###-tns-completion-end-###
