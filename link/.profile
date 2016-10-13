# Esse arquivo é executado uma vez sempre que o usuário fizer login na maquina.
# O arquivo bash_profile faz a mesama coisa quando o login é via terminal, ou
# ssh
# O bashrc é executado a cada nova janela de terminal

if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi
