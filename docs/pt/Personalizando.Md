
# Configuração de Variavéis do Dotfiles
Abra o arquivo ~/.dotfilesconfig.local e altere as configurações que quiser
Caso o arquivo não exista você pode copia-lo da pasta ~/.dotfiles/copy/.dotfilesconfig.local.example

# Configuração de Variavéis do Git
Abra o arquivo ~/.gitconfig.local e altere as configurações que quiser
Caso o arquivo não exista você pode copia-lo da pasta ~/.dotfiles/copy/.gitconfig.local.example

# Criando aliases personalizados
Crie o arquivo .aliases na sua raiz e adicione uma linha como a de baixo:
```
alias gm="git commit"
```

# Extendendo os EXPORTS's 
Crie o arquivo .exports na sua raiz e adicione uma linha como a de baixo:
```
export LANG="en_US.UTF-8";
```

# Extendendo os PATH's 
Crie o arquivo .path na sua raiz e adicione uma linha como a de baixo:
```
export PATH="$DOTFILES/bin:$PATH"
```