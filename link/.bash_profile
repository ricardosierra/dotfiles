#
# Esse arquivo é executado uma vez sempre que o usuário fizer login na maquina.
# O arquivo profile faz a mesama coisa quando o login é via terminal, ou
# ssh
# O bashrc é executado a cada nova janela de terminal

#echo 'Loading bash_profile ...'

[ -r ~/.profile ] && . ~/.profile             # set up environment, once, Bourne-sh syntax only


if [ $(uname) == "Darwin" ];
then
    source ~/.bash_profile_osx
elif [ $(uname) == "Linux" ]
then
		source ~/.bash_profile_ubuntu
fi

# SSH Agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi




export PATH="/home/sierra/.local/share/solana/install/active_release/bin:$PATH"