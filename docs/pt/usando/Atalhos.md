# Referência Completa de Atalhos e Funções

Tudo que está disponível no shell após instalar os dotfiles — aliases, funções e comandos úteis.

> **Como usar esta página:** cada seção tem uma tabela com o alias/função, o que ele faz de verdade, e um exemplo quando necessário. Para ver o código-fonte de qualquer item, o arquivo está indicado no cabeçalho da seção.

---

## Sumário

- [Navegação e Arquivos](#navegacao-e-arquivos)
- [Git — Básico](#git--basico)
- [Git — Avançado](#git--avancado)
- [Workflow Git (branches automáticos)](#workflow-git)
- [Docker](#docker)
- [Docker — Shells rápidos](#docker--shells-rapidos)
- [Docker — Limpeza](#docker--limpeza)
- [AWS / ECS](#aws--ecs)
- [Tmux](#tmux)
- [Sistema e Pacotes](#sistema-e-pacotes)
- [Rede](#rede)
- [Desenvolvimento](#desenvolvimento)
- [Segurança](#seguranca)
- [Timer do Claude](#timer-do-claude)
- [Utilitários](#utilitarios)
- [Notas e Tarefas](#notas-e-tarefas)
- [Aliases Pessoais](#aliases-pessoais)

---

## Navegação e Arquivos

**Fonte:** `source/50_file.sh`

### Listagem

| Alias | Equivalente | Descrição |
|-------|-------------|-----------|
| `ls` | `ls -G` / `ls --color` | Listagem colorida (detecta macOS vs Linux) |
| `l` | `ls -lF` | Formato longo com cores |
| `la` | `ls -laF` | Inclui arquivos ocultos (`.`) |
| `ll` | `tree -aLpughDFiC 1` | Tree visual (ou `ls -al` se tree não tiver) |
| `lsd` | — | Lista só diretórios |

### Navegação

| Alias/Função | O que faz |
|-------------|-----------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `.....` | `cd ../../../..` |
| `~` | `cd ~` (vai pra home) |
| `-` | `cd -` (volta pro diretório anterior) |
| `dl` | `cd ~/Downloads` |
| `cl [dir]` | `cd` + `ls` numa tacada só |
| `md <dir>` / `mkd <dir>` | Cria pasta e entra nela |
| `tmpd [prefixo]` | Cria pasta temporária em `/tmp` e entra |
| `z <trecho>` | Vai pro diretório mais visitado que contém o trecho |

### Arquivos

| Alias/Função | O que faz |
|-------------|-----------|
| `cp` | `cp -i` — confirma antes de sobrescrever |
| `mv` | `mv -i` — confirma antes de sobrescrever |
| `untar <arq>` | `tar xvf` — extrai sem precisar lembrar as flags |
| `extract <arq>` | Detecta o formato e extrai (zip, gz, bz2, rar, 7z, xz…) |
| `targz <dir>` | Cria `.tar.gz` usando o melhor compressor disponível |
| `fs` / `filesize` | Tamanho de arquivo ou pasta (formato legível) |
| `df` | `df -h` — uso dos discos em formato legível |
| `dsstore` | Apaga todos os `.DS_Store` recursivamente |
| `mine` | `sudo chown -R $USER` — toma posse do diretório |
| `map` | `xargs -n1` — aplica um comando item por item |

### Clipboard (Linux)

| Alias | O que faz |
|-------|-----------|
| `pbcopy` | Copia stdin pra área de transferência |
| `pbpaste` | Cola da área de transferência |
| `c` | Remove quebras de linha e copia |
| `cwd` | Copia o caminho do diretório atual |
| `pubkey` | Copia a chave pública SSH |

---

## Git — Básico

**Fonte:** `source/50_vcs.sh`

| Alias/Função | Equivalente | Descrição |
|-------------|-------------|-----------|
| `g` | `git` | Atalho principal |
| `ga [arquivos]` | `git add .` | Adiciona arquivos (tudo se não informar) |
| `gadd` | `git add --all && git status` | Add + mostra status |
| `gs` / `gst` | `git status` | Status do repo |
| `gd` | `git diff` | Diff do working tree |
| `gdc` | `git diff --cached` | Diff do que está staged |
| `gl` | `git log` | Log simples |
| `gg` | `git log --graph --oneline --all` | Log em grafo bonito |
| `gp` / `push` | `git push` | Push |
| `gu` / `pull` | `git pull` | Pull |
| `gpup` | `git push --set-upstream origin <branch>` | Push + seta upstream |
| `gpa` | `git push --all` | Push de todos os branches |
| `cmt "msg"` | `git commit -m "msg"` | Commita com mensagem |
| `cmta "msg"` | `git commit -am "msg"` | Add + commit numa tacada |
| `gb` | `git branch` | Lista branches locais |
| `gba` | `git branch -a` | Lista todos os branches (incluindo remotos) |
| `gbup` | — | Seta upstream do branch atual |
| `gc [branch]` | `git checkout master` | Checkout (master se não informar) |
| `gco` | = `gc` | Alias alternativo |
| `gcb <branch>` / `gbc` | `git checkout -b` | Cria e entra no branch |
| `gr` | `git remote` | Gerencia remotes |
| `grv` | `git remote -v` | Mostra URLs dos remotes |
| `grr <remote>` | `git remote rm` | Remove um remote |
| `gcl` | `git clone` | Clone |
| `gcd` | — | Vai pra raiz do repositório |
| `gbs` | — | Nome do branch atual (ou SHA em detached HEAD) |
| `gsu` | — | Seta upstream do branch atual se não tiver |

---

## Git — Avançado

**Fonte:** `source/50_vcs.sh`

### Navegação em subdiretórios

| Alias | O que faz |
|-------|-----------|
| `gu-all` | `git pull` em todos os subdiretórios |
| `gp-all` | `git push` em todos os subdiretórios |
| `gs-all` | `git status` em todos os subdiretórios |

### GitHub / URLs

| Alias/Função | Descrição |
|-------------|-----------|
| `gurl [remote]` | URL do repositório no GitHub/Bitbucket |
| `gurlp` | URL incluindo branch atual + path relativo |
| `gpu` | Abre o branch atual no browser |
| `gfu [n]` | Abre o N-ésimo commit no GitHub (padrão: último) |
| `gra <user>` | Adiciona remote do GitHub pelo username |
| `repo` | Abre o repositório no browser (GitHub ou Bitbucket) |
| `gitio <slug> <url>` | Cria URL curta no git.io |

### Log com URLs clicáveis (iTerm)

| Alias | Descrição |
|-------|-----------|
| `gf [args]` | Log com URLs cmd-clicáveis no iTerm |
| `gf1` … `gf5` | Últimos 1 a 5 commits com URLs |

### Funções avançadas

| Função | Uso | Descrição |
|--------|-----|-----------|
| `grbo <parent> [topic]` | `grbo main feature/x` | Rebaseia topic em cima do parent remoto |
| `ged [rev1] [rev2]` | `ged HEAD~5` | Abre no editor todos os arquivos modificados |
| `gstat [range]` | `gstat HEAD~` | Diff colorido combinando name-status + stat |
| `git_diff_rename <prev> <novo> <antigo>` | — | Diff de arquivo renomeado em formato GitHub |
| `git_pr_blaster [n]` | `git_pr_blaster 3` | Cria N PRs de teste pra estressar o CI |

### macOS (Tower / Kaleidoscope)

| Alias/Função | Descrição |
|-------------|-----------|
| `gt [dir]` | Abre o repo no Tower |
| `gdk` | Diff no Kaleidoscope |
| `gdkc` | Diff staged no Kaleidoscope |

---

## Workflow Git

**Fonte:** `source/100_workflow.sh`

Cria branches padronizados, commita tudo e faz push — tudo numa tacada. Volta pro branch original automaticamente.

| Alias | Função completa | Branch criado | Uso |
|-------|----------------|---------------|-----|
| `wd` / `wf` / `wds` | `workflow-demanda-send` | `feature/<nome>` | `wd "login screen"` |
| `wf` / `wfs` / `wffs` | `workflow-fix-send` | `fix/<nome>` | `wf "botão quebrado"` |
| `wh` / `whs` / `wfhs` | `workflow-hotfix-send` | `hotfix/<nome>` | `wh "crash em prod"` |
| `wp` / `wfp` | `wfp` | — | Faz merge da feature no dev e push pro master |
| `wtu` / `wftu` | `workflow-tag-up` | — | Incrementa a tag de versão (experimental) |

**Exemplo:**
```bash
wd "tela de login"
# → cria feature/tela-de-login
# → git add . && git commit -am "tela de login" && git push
# → volta pro branch original
```

---

## Docker

**Fonte:** `source/30_docker.sh`

### Containers — Executar

| Alias/Função | Equivalente | Descrição |
|-------------|-------------|-----------|
| `drun` | `docker run -it --rm` | Interativo, remove ao sair |
| `dexec <nome>` | — | Abre bash (busca parcial no nome) |
| `dc` / `docker_exec` | = `dockexec` | Abre bash num container |
| `dockexec <id>` | `docker exec -it $@ bash` | Bash por ID |
| `dockexecl` | — | Bash no último container |
| `dex <id>` | `docker exec -it $@ /bin/sh` | sh por ID (Alpine/BusyBox) |
| `dexl` | — | sh no último container |
| `de <servico>` | — | Bash no serviço docker-compose (usa nome da pasta) |

### Containers — Listar e Inspecionar

| Alias | Equivalente | Descrição |
|-------|-------------|-----------|
| `dls` | `docker ps -a` | Todos os containers |
| `dlsl` | `docker ps -l` | Último container |
| `dcount` | `docker ps -qa \| wc -l` | Quantidade |
| `din` | `docker inspect` | Inspeciona um container |
| `dinl` | — | Inspeciona o último |
| `dina` | — | Inspeciona todos |
| `dp` / `dport` | `docker port` | Portas do último container |
| `dlog` | `docker logs` | Logs do último container |
| `dl <id>` | `docker logs` | Logs de um container |

### Containers — Iniciar / Parar

| Alias | Descrição |
|-------|-----------|
| `start` | Inicia todos os containers |
| `stop` | Para todos os containers |
| `startl` | Inicia o último |
| `stopl` | Para o último |
| `dtop <id>` | Para um container específico |
| `dra` | Para e remove todos (gracioso) |
| `drk` | Mata e remove todos |

### Containers — Remover

| Alias | Descrição |
|-------|-----------|
| `dr <id>` | Remove forçado |
| `drl` | Remove o último |
| `drall` | Remove todos |
| `delcon <filtro>` | Remove containers que batem com o filtro |
| `stopcon <filtro>` | Para containers que batem com o filtro |

### Imagens

| Alias/Função | Descrição |
|-------------|-----------|
| `di` | Lista imagens |
| `di5` | Últimas 5 imagens |
| `dri <img>` | Remove imagem |
| `db <tag>` | Build com tag |
| `dbc <tag>` | Build sem cache |
| `delnone` | Apaga imagens órfãs (`<none>`) |
| `delimg <filtro>` | Apaga imagens que batem com filtro |

### Redes

| Alias | Descrição |
|-------|-----------|
| `dnl` | Lista redes |
| `dnc` | Cria rede |
| `dnr` | Remove rede |
| `dni` | Inspeciona rede |
| `dnia` | Inspeciona todas as redes |
| `dnrm` | Remove todas as redes |
| `dip <id>` | IP de um container |
| `dipl` | IP de todos os containers |
| `dnnet` | Subnets e gateways de todas as redes |

### Docker Machine (legado)

| Alias | Descrição |
|-------|-----------|
| `dm` | `sudo docker-machine` |
| `dml` | Lista máquinas |
| `devstar` | Inicia máquina "dev" |
| `denv` | Mostra variáveis Docker no env |
| `dkenv` | Ativa ambiente da máquina "dev" |
| `dmc` | Cria máquina |
| `dmip` | IP de uma máquina |
| `dmstar` / `mstar` | Inicia máquina |
| `dmstop` / `mstop` | Para máquina |
| `dmk` | Mata máquina |

### docker-compose

| Alias | Descrição |
|-------|-----------|
| `up` | `docker-compose up -d` |
| `down` | `docker-compose down` |
| `docker-restart` | down + rm + up --build |
| `docker-clean` | down + rm |

### Limpeza

| Função | Descrição |
|--------|-----------|
| `dcleanup` | Remove containers parados + imagens dangling |
| `dclean_container` | Remove todos os containers |
| `dcleanall` | Remove containers + imagens (tudo) |

## Docker — Shells rápidos

Containers de SO prontos pra usar. Os com `rm` no final se destroem ao sair:

| Alias | SO | Comportamento |
|-------|-----|--------------|
| `alpinerm` | Alpine | Remove ao sair |
| `ubunturm` | Ubuntu | Remove ao sair |
| `debianrm` | Debian | Remove ao sair |
| `fedorarm` | Fedora | Remove ao sair |
| `centosrm` | CentOS | Remove ao sair |
| `busyrm` | BusyBox | Remove ao sair |
| `nethostrm` | Ubuntu (net=host) | Remove ao sair |
| `alpine` | Alpine | Para ao sair |
| `ubuntu` | Ubuntu | Para ao sair |
| `debian` | Debian | Para ao sair |
| `alpined` | Alpine | Daemon (background) |
| `ubuntud` | Ubuntu | Daemon (background) |
| `debiand` | Debian | Daemon (background) |

---

## AWS / ECS

**Fonte:** `source/50_aws.sh`

| Função | Uso | Descrição |
|--------|-----|-----------|
| `aws-account` | `aws-account` | Nome da conta AWS atual |
| `aws-list-clusters` | — | Lista clusters ECS |
| `aws-list-services <cluster>` | — | Serviços de um cluster |
| `aws-list-services-by-cluster` | — | Todos serviços agrupados por cluster |
| `aws-list-tasks <cluster> <svc>` | — | Tasks de um serviço |
| `aws-list-task-definitions <c> <s>` | — | Definições de task das tasks ativas |
| `aws-task-definition <c> <s>` | — | Definição atual de uma task |
| `aws-task-definition-env <c> <s>` | — | Variáveis de ambiente da task (VAR=VALOR) |
| `aws-task-definition-env-history <td>` | — | Histórico de mudanças nas variáveis |
| `aws-stop-tasks <c> <svc...>` | — | Para todas as tasks de um serviço |
| `aws-logs <grupo> <stream>` | — | Lê CloudWatch Logs com paginação |

---

## Tmux

**Fonte:** `source/10_tmux.sh`

| Alias/Função | Descrição |
|-------------|-----------|
| `tls` | Lista sessões tmux abertas |
| `tm [args]` | Conecta a sessão existente ou cria nova; sai do shell ao fechar |
| `qq [n] [dir]` | Abre janela nova no layout main-vertical com N painéis |
| `q2` | `qq 2` — 2 painéis |
| `q3` | `qq 3` — 3 painéis |
| `run_in_fresh_tmux_window <cmd>` | Roda comando numa janela limpa (cria nova se tiver multiplos painéis) |

**Exemplo:**
```bash
qq 2 ~/Dev/meu-projeto   # janela com 2 painéis no projeto
```

---

## Sistema e Pacotes

**Fonte:** `source/50_system.sh`

Comandos unificados — funcionam no macOS (brew), Debian/Ubuntu (apt), Arch (pacman) e RHEL/CentOS (yum):

| Alias | O que faz |
|-------|-----------|
| `update` | Atualiza todos os pacotes |
| `install <pkg>` | Instala um pacote |
| `remove <pkg>` | Remove um pacote |
| `search <pkg>` | Busca pacotes |
| `e` | `exit` — sai do shell |
| `ipif <ip\|host>` | Info geográfica de IP ou hostname |

---

## Rede

**Fontes:** `source/50_net.sh`, `source/50_file.sh`

| Alias/Função | O que faz |
|-------------|-----------|
| `wanip` | IP público via DNS do OpenDNS |
| `pubip` | Alias pra `wanip` |
| `localip` | IP local (exclui loopback) |
| `ips` | Todos os IPs (IPv4 e IPv6) |
| `whois <domínio>` | WHOIS com servidor unificado |
| `flush` | Limpa cache de DNS (macOS) |
| `httpdump` | Monitora tráfego HTTP na en1 |
| `sniff` | Captura GET/POST na en1 |
| `pingtest [host]` | Ping com feedback de áudio ("ping" em voz alta) |
| `digga <domínio>` | `dig` limpo mostrando só o essencial |
| `mwiki <termo>` | Resumo do Wikipedia via DNS |
| `getcertnames <domínio>` | Mostra CN e SANs do certificado SSL |

---

## Desenvolvimento

**Fontes:** `source/50_developer.sh`, `source/20_system.sh`

| Alias/Função | Uso | Descrição |
|-------------|-----|-----------|
| `server [porta]` | `server 3000` | Servidor HTTP local (Python, padrão: 8000) |
| `csource <arquivo.c>` | `csource main.c` | Compila e executa C, sem deixar rastro |
| `gostatic [dir] [modo]` | `gostatic . netgo` | Binário Go estático pra Linux |
| `gogo <projeto>` | `gogo meu-app` | Vai pra pasta do projeto no GOPATH |
| `golistdeps` | — | Lista dependências externas do projeto Go |
| `calc "expressão"` | `calc "2^10"` | Calculadora com 10 casas decimais |
| `json <string\|pipe>` | `json '{"x":1}'` | Formata e colore JSON |
| `gz <arquivo>` | `gz bundle.js` | Compara tamanho original vs gzipado |
| `escape "texto"` | — | Converte pra sequências `\x{XX}` Unicode |
| `codepoint "char"` | `codepoint é` | Code point Unicode de um caractere |
| `v [arquivo]` | `v` | Abre vim (diretório atual se sem argumento) |
| `o [caminho]` | `o .` | Abre com xdg-open (explorador de arquivos) |
| `tre [args]` | — | `tree` com cores, arquivos ocultos, paginado |
| `man <cmd>` | — | Man page com cores bonitas |
| `diff` | — | `git diff --color-words` (sobrescreve o padrão) |
| `urlencode "str"` | — | Encode pra URL |
| `dataurl <arquivo>` | `dataurl logo.png` | Converte arquivo pra Data URL base64 |
| `mergepdf -o out.pdf ...` | — | Junta PDFs (macOS) |
| `GET` / `POST` / etc. | `GET http://...` | HTTP requests direto da linha de comando |

---

## Segurança

**Fonte:** `source/50_security.sh`

> Use apenas em redes/sistemas com autorização.

| Função | Descrição |
|--------|-----------|
| `hostscan` | Ping sweep numa faixa de IPs (pede o range) |
| `portknock <host> <portas...>` | Port knocking via nmap |
| `webscan <host>` | SYN scan + dirbusting (precisa ser root) |
| `zonetransfer` | Tenta transferência de zona DNS (pede o domínio) |

---

## Timer do Claude

**Fontes:** `source/50_misc.sh`, `scripts/claude_timer.sh`, `scripts/claude_set.sh`

O timer aparece na barra do tmux e mostra quanto tempo de janela de uso resta (5h total) + o percentual de uso de tokens.

| Alias/Script | Uso | Descrição |
|-------------|-----|-----------|
| `claude-reset` | — | Zera o timer e o percentual |
| `claude-set <tempo> [%]` | `claude-set 3h29m 86%` | Sincroniza com o dashboard |

**Cores na barra tmux:**
- Verde: mais de 2 horas restando
- Amarelo: entre 30 min e 2 horas
- Vermelho: menos de 30 min

---

## Utilitários

**Fontes:** `source/50_misc.sh`, `source/20_system.sh`

| Alias/Função | Uso | Descrição |
|-------------|-----|-----------|
| `loop [delay] <cmd>` | `loop 5 echo "oi"` | Repete o comando a cada N segundos |
| `loopc [delay] 'cmds'` | `loopc 5 'echo a; echo b'` | Mesmo, mas aceita múltiplos comandos |
| `timer` | — | Cronômetro (Ctrl-D pra parar) |
| `week` | — | Número da semana atual |
| `afk` | — | Trava a tela (i3lock fundo preto) |
| `hosts` | — | Edita `/etc/hosts` com sudo |
| `grep` | — | Sempre colorido |
| `titlebar "título"` | — | Muda o título da barra do terminal |
| `sudo` | — | Permite usar aliases com sudo |
| `dbs [session\|system]` | — | Lista serviços D-Bus |
| `isup <url>` | `isup https://meusite.com` | Checa se uma URL está no ar |
| `openimage <img>` | — | Abre imagens com feh |
| `xname <window-id>` | — | Nome e classe de uma janela X11 |

---

## Notas e Tarefas

**Fonte:** `source/50_file.sh`

### `note` — Bloco de notas em `~/.notes`

```bash
note               # mostra tudo
note minha ideia   # adiciona uma nota
note -c            # limpa tudo
```

### `todo` — Lista de tarefas em `~/.todo`

```bash
todo               # mostra as tarefas
todo comprar leite # adiciona tarefa
todo -l            # lista numerada
todo -r            # remove pelo número
todo -c            # limpa tudo
```

---

## Aliases Pessoais

**Fonte:** `link/.aliases`

| Alias | O que faz |
|-------|-----------|
| `m` | `code .` — abre o VS Code no diretório atual |
| `c` | `composer` (PHP) |
| `a` | `phpstan analyse` |
| `products` | `cd $DEV_FOLDER_PRODUCTS` |
| `mp` | `cd .../MinhaPeca` |
| `Girls` | `cd .../Girls` |
| `Boss` | `cd .../Boss` |
| `banlek` | `cd .../Banlek` |
| `Novacao` | `cd .../novacao` |
| `eng` | `cd .../eunagarupa` |
| `libs` | `cd $DEV_FOLDER_LIBS` |
| `Tools` | `cd .../Tools` |
| `Facilitador` | `cd .../Facilitador` |
| `rica` | `cd $BUSINESS_FOLDER_ROOT` |
| `docker-restart` | `docker-compose down && rm && up --build` |
| `docker-clean` | `docker-compose down && rm` |

---

*Última atualização: Maio 2026*
