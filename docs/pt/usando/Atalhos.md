# Atalhos Docker

Referência completa dos aliases e funções Docker disponíveis após instalar o dotfiles.

---

## Containers — executar

| Alias/Função | Comando real | Descrição |
|-------------|-------------|-----------|
| `drun` | `docker run -it --rm` | Executar container interativo e remover ao sair |
| `dc` / `docker_exec` | `dockexec` | Abrir bash em um container pelo nome |
| `dexec` / `dex` | `docker exec -it $@ /bin/sh` | Shell em container pelo nome |
| `dexl` | shell no último container | Shell no container criado mais recentemente |

---

## Containers — listar e inspecionar

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `dls` | `docker ps -a` | Listar todos os containers |
| `dlsl` | `docker ps -l` | Último container criado |
| `dcount` | `docker ps -qa \| wc -l` | Contar containers |
| `din` | `docker inspect` | Inspecionar container |
| `dinl` | inspect do último | Inspecionar o último container |
| `dina` | inspect de todos | Inspecionar todos os containers |
| `dp` | `docker port` do último | Portas do último container |
| `dport` | `docker port` do último | Alias para `dp` |
| `dlog` | logs do último | Logs do último container |
| `dl` | `docker logs` | Logs de um container |

---

## Containers — iniciar e parar

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `start` | `docker start $(docker ps -qa)` | Iniciar todos os containers |
| `stop` | `docker stop $(docker ps -qa)` | Parar todos os containers |
| `startl` | start do último | Iniciar o último container |
| `stopl` | stop do último | Parar o último container |
| `dtop` | `docker stop` | Parar container específico |

---

## Containers — remover

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `dr` | `docker rm -f` | Remover container forçadamente |
| `drl` | remove o último | Remover o último container |
| `drall` | remove todos | Remover todos os containers |
| `dra` | stop + remove todos | Parar e remover todos graciosamente |
| `drk` | kill + remove todos | Matar e remover todos |

---

## Imagens

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `di` | `docker images` | Listar imagens |
| `di5` | `docker images \| head -n5` | Últimas 5 imagens |
| `dri` | `docker rmi` | Remover imagem |
| `db` | `docker build -t` | Build de imagem com tag |
| `dbc` | `docker build -t --no-cache` | Build sem cache |

---

## Redes

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `dnr` | `docker network rm` | Remover rede |
| `dnl` | `docker network ls` | Listar redes |
| `dnc` | `docker network create` | Criar rede |
| `dni` | `docker network inspect` | Inspecionar rede |
| `dnia` | inspect de todas as redes | Inspecionar todas as redes |
| `dnrm` | remove todas as redes | Remover todas as redes |
| `dip` | inspect do IP de um container | IP de um container específico |
| `dipl` | IPs de todos containers | Listar IPs de todos os containers |
| `dockip` | `docker inspect --format NetworkSettings.IPAddress` | IP de um container |
| `dockipl` | IP de todos os ativos | IP de todos os containers ativos |
| `dnip` | IPs parseados | Todos os IPs em execução |
| `dnnet` | subnets de todas as redes | Subnets e gateways de todas as redes |

---

## Docker Machine

| Alias | Comando real | Descrição |
|-------|-------------|-----------|
| `dm` | `sudo docker-machine` | Docker Machine com sudo |
| `dml` | `docker-machine ls` | Listar máquinas |
| `devstar` | `docker-machine start dev` | Iniciar máquina "dev" |
| `denv` | `env \| grep DOCKER` | Ver variáveis Docker |
| `dkenv` | `eval "$(docker-machine env dev)"` | Ativar ambiente da máquina "dev" |
| `dmc` | `docker-machine create` | Criar máquina |
| `dmip` | `docker-machine ip` | IP de uma máquina |
| `dmstar` / `mstar` | `docker-machine start` | Iniciar máquina |
| `dmstop` / `mstop` | `docker-machine stop` | Parar máquina |
| `dmk` | `docker-machine kill` | Matar máquina |
| `dmin` | inspect da última máquina | Inspecionar última máquina |
| `dmrm` | remove a última máquina | Remover última máquina |
| `mstar1` | start da última máquina | Iniciar a última máquina listada |
| `mstop1` | stop da última máquina | Parar a última máquina listada |

---

## Shells Docker sob demanda

Aliases para abrir um shell interativo em um container de SO — o container é **removido ao sair** (`--rm`):

| Alias | SO | Comportamento |
|-------|-----|--------------|
| `alpinerm` | Alpine | Primeiro plano, remove ao sair |
| `ubunturm` | Ubuntu | Primeiro plano, remove ao sair |
| `debianrm` | Debian | Primeiro plano, remove ao sair |
| `fedorarm` | Fedora | Primeiro plano, remove ao sair |
| `centosrm` | CentOS | Primeiro plano, remove ao sair |
| `busyrm` | BusyBox | Primeiro plano, remove ao sair |
| `nethostrm` | Ubuntu (net=host) | Primeiro plano, remove ao sair |

Aliases que **param ao sair** (sem `--rm`):

| Alias | SO |
|-------|-----|
| `alpine` | Alpine |
| `ubuntu` | Ubuntu |
| `debian` | Debian |
| `fedora` | Fedora |
| `busy` | BusyBox |
| `nethost` | Ubuntu (net=host) |

Aliases em modo **daemon** (background):

| Alias | SO |
|-------|-----|
| `alpined` | Alpine |
| `ubuntud` | Ubuntu |
| `debiand` | Debian |
| `fedorad` | Fedora |
| `busyd` | BusyBox |
