# Índice de Atalhos e Uso

Referência rápida de todos os aliases e funções disponíveis após instalar o dotfiles.

---

## Categorias

| Categoria | Arquivo |
|-----------|---------|
| [Docker e containers](#docker) | [Atalhos.md](Atalhos.md) |
| [Navegação e arquivos](#navegação-e-arquivos) | abaixo |
| [Git e workflow](#git-e-workflow) | abaixo |
| [Rede e sistema](#rede-e-sistema) | abaixo |
| [tmux e terminal](#tmux-e-terminal) | abaixo |
| [Claude timer](#claude-timer) | abaixo |

---

## Navegação e arquivos

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `l` | `ls -lF` | Listagem detalhada |
| `la` | `ls -laF` | Listagem com ocultos |
| `..` | `cd ..` | Subir um nível |
| `...` | `cd ../..` | Subir dois níveis |
| `....` | `cd ../../..` | Subir três níveis |
| `.....` | `cd ../../../..` | Subir quatro níveis |
| `~` | `cd ~` | Ir para home |
| `-` | `cd -` | Voltar ao diretório anterior |
| `dl` | `cd ~/Downloads` | Ir para Downloads |
| `h` | `history` | Ver histórico |
| `cp` | `cp -i` | Copiar com confirmação |
| `mv` | `mv -i` | Mover com confirmação |
| `untar` | `tar xvf` | Extrair arquivo tar |
| `dsstore` | find+delete | Remover todos os arquivos `.DS_Store` |
| `mine` | `sudo chown -R $USER` | Tomar posse de diretório |
| `fs` | `stat -f` | Ver tamanho de arquivo |
| `df` | `df -h` | Uso de disco legível |
| `week` | `date +%V` | Número da semana atual |

---

## Git e workflow

| Alias/Comando | Descrição |
|--------------|-----------|
| `jf PROJ-ID Descricao` | Criar branch, commitar e enviar (workflow completo) |
| `gf` | Atalho para `jf` |
| `wfd` / `wd` | workflow-demanda-send |
| `wfs` / `wf` | workflow-fix-send |
| `whs` / `wh` | workflow-hotfix-send |
| `wp` | workflow-publish |
| `wtu` | workflow-tag-up |

---

## Rede e sistema

| Alias | Descrição |
|-------|-----------|
| `pubip` | IP público externo |
| `localip` | IP local da rede |
| `ips` | Todos os IPs das interfaces |
| `flush` | Limpar cache DNS (macOS) |
| `sniff` | Monitorar tráfego HTTP na en1 |
| `httpdump` | Dump de headers HTTP |
| `hosts` | Editar `/etc/hosts` com sudo |
| `pubkey` | Copiar chave pública SSH |
| `prikey` | Copiar chave privada SSH |

---

## tmux e terminal

| Alias/Comando | Descrição |
|--------------|-----------|
| `tls` | `tmux ls` — listar sessões |
| `cl` | `cd` + `ls` — navegar e listar |
| `src` | Recarregar todos os arquivos source sem reiniciar o shell |
| `timer` | Timer simples com Ctrl-D para parar |

---

## Claude timer

| Comando | Descrição |
|---------|-----------|
| `claude-reset` | Zerar o timer (remove `/tmp/claude_start`) |
| `claude-set 3h29m 86%` | Sincronizar com o valor real do dashboard do Claude |

---

## Docker

Ver [Atalhos.md](Atalhos.md) para a referência completa de Docker e Docker Machine.
