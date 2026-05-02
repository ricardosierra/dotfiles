# Configuração e Personalização

## Variáveis do dotfiles

Abra o arquivo `~/.dotfilesconfig.local` e altere as configurações desejadas.  
Se o arquivo não existir, copie o exemplo:

```sh
cp ~/.dotfiles/copy/.dotfilesconfig.local.example ~/.dotfilesconfig.local
```

---

## Configuração do Git

Abra `~/.gitconfig.local` e ajuste conforme necessário.  
Se o arquivo não existir:

```sh
cp ~/.dotfiles/copy/.gitconfig.local.example ~/.gitconfig.local
```

Configurações típicas:

```ini
[user]
    name = Seu Nome
    email = seu@email.com
    signingkey = SUA_CHAVE_GPG

[github]
    user = seu-usuario-github
```

---

## Criando aliases personalizados

Crie o arquivo `~/.aliases` na raiz do seu home e adicione suas linhas:

```sh
alias gm="git commit"
alias pn="pnpm"
alias k="kubectl"
```

O arquivo é carregado automaticamente em todo novo shell.

---

## Extendendo exports

Crie `~/.exports` e adicione suas variáveis de ambiente:

```sh
export LANG="pt_BR.UTF-8"
export EDITOR="nvim"
export NODE_ENV="development"
```

---

## Extendendo o PATH

Crie `~/.path` e adicione entradas extras:

```sh
export PATH="$HOME/.local/bin:$PATH"
export PATH="$DOTFILES/bin:$PATH"
```

---

## Adicionando funções ao shell

Crie um arquivo em `~/.dotfiles/source/` com prefixo numérico para controlar a ordem:

```sh
# ~/.dotfiles/source/60_meutime.sh

alias gs="git status"
myfunc() {
    echo "Olá, $1!"
}
```

O arquivo será carregado automaticamente em todo novo shell após `src` ou ao abrir um novo terminal.

---

## Recarregando sem reiniciar o shell

```sh
src
```

Equivale a re-sourcear todos os arquivos de `/source` sem fechar o terminal.

---

## Timer Claude no tmux

Para sincronizar o timer com o uso real do dashboard do Claude:

```sh
claude-set 3h29m 86%
```

Para zerar o timer:

```sh
claude-reset
```

Veja a seção de limitações no [README](../../README.md#claude-usage-timer).
