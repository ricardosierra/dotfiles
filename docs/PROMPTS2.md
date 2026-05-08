# Prompts de Revisão, Testes e Melhoria

Cada prompt é **auto-contido e colável** em nova sessão. Paths absolutos, restrições explícitas, critério de pronto incluído.

Complementa [`PROMPTS.md`](PROMPTS.md) (foco em bug fixes pontuais).

---

## Índice rápido

| # | Categoria | Título |
|---|-----------|--------|
| 7 | Testes | Escrever testes unitários para funções bash (bats) |
| 8 | Testes | Testar funções git de `50_vcs.sh` |
| 9 | Testes | Testar funções de arquivo de `50_file.sh` |
| 10 | Testes | Smoke test do install completo em container Docker |
| 11 | Testes | Testar portabilidade macOS vs Ubuntu |
| 12 | Testes | Testar o `claude_timer.sh` com entradas edge-case |
| 13 | Qualidade | Shellcheck completo em todos os scripts próprios |
| 14 | Qualidade | Audit de quoting — variáveis sem aspas |
| 15 | Qualidade | Verificar `set -euo pipefail` / error handling |
| 16 | Qualidade | Inventário e deduplicação de aliases |
| 17 | Qualidade | Inventário de funções exportadas e conflitos de nome |
| 18 | Qualidade | Revisar ordem de carregamento dos source files |
| 19 | Qualidade | Refatorar detecção de OS em `bin/dotfiles` |
| 20 | Qualidade | Revisão do `.gitconfig` — configs obsoletas ou inseguras |
| 21 | Segurança | Audit de `eval` em `bin/dotfiles` (análise detalhada) |
| 22 | Segurança | Verificar exposição de secrets em arquivos rastreados |
| 23 | Segurança | Audit de `curl \| bash` e downloads não verificados |
| 24 | Segurança | Revisão de permissões de arquivos em `copy/` |
| 25 | Performance | Medir e otimizar tempo de carregamento do shell |
| 26 | Performance | Lazy loading de tools pesados (rbenv, nvm, pyenv) |
| 27 | Performance | Eliminar subshells desnecessários no prompt |
| 28 | Configuração | Revisão completa do `.vimrc` — plugins obsoletos |
| 29 | Configuração | Revisão do `.tmux.conf` — modernizar para tmux 3.x |
| 30 | Configuração | Revisão de keybindings do vim — conflitos e sobreposições |
| 31 | Configuração | Revisão do `.zshrc` / `link/.commonrc` |
| 32 | Manutenibilidade | Dependências externas — o que o dotfiles assume instalado |
| 33 | Manutenibilidade | Revisar copy/ vs link/ — o que deve mudar de categoria |
| 34 | Manutenibilidade | Atualizar docs/ para refletir correções recentes |
| 35 | Manutenibilidade | Criar Brewfile centralizado a partir dos init scripts |
| 36 | Modernização | Substituir plugins vim deprecated no `.vimrc` |
| 37 | Modernização | Avaliar migração de oh-my-zsh para alternativa mais leve |
| 38 | Modernização | Modernizar syntax bash 3 → bash 4/5 nos scripts |
| 39 | Sugestões | Adicionar suporte a XDG Base Directory nos configs |
| 40 | Sugestões | Criar comando `dotfiles doctor` para auto-diagnóstico |
| 41 | Sugestões | Adicionar tema/colorscheme consistente entre tmux, vim e shell |
| 42 | Recomendações | Avaliar adoção de chezmoi ou dotbot para deploy |

---

## 7. Escrever testes unitários para funções bash (bats)

O repo tem um diretório `~/.dotfiles/test/` mas poucos testes. Este prompt cria cobertura usando [bats-core](https://github.com/bats-core/bats-core).

```
Em ~/.dotfiles/test/ há testes bash mas a cobertura é mínima.
Quero adicionar testes unitários usando bats-core para as
funções mais críticas dos source files.

Instale bats-core como dependência de dev (homebrew: `bats-core`).

Crie os seguintes arquivos de teste:

1. test/50_file.bats — cobrir:
   - extract(): arquivo .tar.gz, .zip, .tar.bz2, extensão
     desconhecida (deve printar erro sem abortar)
   - tmpd(): sem args cria dir temporário; com arg usa o nome
   - targz(): comprime e descomprime voltando ao original

2. test/50_vcs.bats — cobrir:
   - cmt(): mensagem com espaços e apóstrofos não quebra
   - gbs(): retorna nome do branch atual ou SHA se detached
   - gsu(): não duplica upstream se já configurado

3. test/30_connection.bats — cobrir:
   - ssh wrapper: repassa todos os args para /usr/bin/ssh
     (mock /usr/bin/ssh com um stub que imprime $@)
   - git wrapper: idem para /usr/bin/git

Para cada teste:
- Use `setup()` para criar fixtures temporários em $BATS_TMPDIR
- Use `teardown()` para limpar
- Mock dependências externas com funções stub exportadas
- Não escreva testes que façam rede ou escrevam fora de TMPDIR

Adicione `brew install bats-core` ao
~/.dotfiles/init/30_osx_homebrew_recipes.sh.

Critério de pronto: `bats test/*.bats` passa sem erros em
macOS e Ubuntu 22.04 (dentro de docker).
```

---

## 8. Testar funções git de `50_vcs.sh`

Funções como `grbo`, `gf`, `gstat` são complexas e não têm testes.

```
~/.dotfiles/source/50_vcs.sh contém funções git avançadas
sem cobertura de teste. Quero testes bats focados nas mais
críticas.

Para cada função abaixo, crie test cases em
test/50_vcs_git.bats usando um repositório git temporário
(crie com `git init` em $BATS_TMPDIR):

1. grbo():
   - Falha se parent branch não informado (exit != 0, msg "Missing parent")
   - Falha se parent branch não existe localmente
   - Falha se topic == parent ("must be different")
   - Sucesso com mocks de `git fetch` e `git rebase`

2. gstat():
   - Retorna código 0 em repo limpo
   - Retorna código != 0 se `git diff` falha
   - Output contém o nome do arquivo modificado

3. cmt() e cmta():
   - Mensagem com apóstrofo: `cmt "it's done"` → git recebe
     `commit -m "it's done"` (não quebra)
   - Mensagem vazia: deve falhar com erro do git (não com erro
     do wrapper)

4. gra():
   - Falha com erro de usage se != 1 argumento
   - Usa `git remote show -n origin` para detectar repo (mock)

Setup necessário:
  git config --global user.email "test@test.com"
  git config --global user.name "Test"
  git init && git commit --allow-empty -m "init"

Não faça push real nem acesse github.com.

Critério de pronto: `bats test/50_vcs_git.bats` passa com
todos os casos verdes.
```

---

## 9. Testar funções de arquivo de `50_file.sh`

```
Crie testes para as funções de manipulação de arquivo em
~/.dotfiles/source/50_file.sh. Use bats-core.

Arquivo: test/50_file.bats

Funções a cobrir:

1. extract():
   - Dado um .tar.gz criado com conteúdo conhecido, extrai
     e verifica o arquivo interno existe
   - Dado arquivo .zip, idem
   - Dado extensão desconhecida (.xyz), imprime mensagem de
     erro e retorna código != 0
   - Dado path que não existe, imprime "file does not exist"

2. targz():
   - Comprime um diretório temporário
   - Arquivo .tar.gz é criado com nome correto
   - Descomprimindo volta ao conteúdo original (diff -r)

3. tmpd():
   - Sem argumento: cria dir em /tmp/, $PWD muda para lá
   - Com argumento "foo": dir criado tem "foo" no nome
   - Dir criado tem permissão 700 (privado)

4. dataurl():
   - Dado arquivo .png de 1x1 pixel (fixture), output começa
     com "data:image/png;base64,"
   - Dado arquivo .txt, output começa com "data:text/plain"

Fixtures: crie-os em setup() dentro de $BATS_TMPDIR.
Não dependa de clipboards (xclip/pbcopy) nos testes — mock.

Critério de pronto: `bats test/50_file.bats` zero falhas.
```

---

## 10. Smoke test do install completo em container Docker

```
Quero um smoke test que valide que o `bin/dotfiles` roda do
zero num sistema limpo, sem interação manual.

Crie ~/.dotfiles/test/docker/smoke-test.sh e um
~/.dotfiles/test/docker/Dockerfile.ubuntu com:

Dockerfile:
  FROM ubuntu:22.04
  RUN apt-get update && apt-get install -y \
      git curl bash zsh sudo \
      && useradd -m -s /bin/bash testuser \
      && echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  COPY . /home/testuser/.dotfiles
  RUN chown -R testuser: /home/testuser/.dotfiles
  USER testuser
  WORKDIR /home/testuser
  CMD ["/home/testuser/.dotfiles/test/docker/smoke-test.sh"]

smoke-test.sh deve:
1. Criar ~/.dotfilesconfig.local mínimo (sem interação)
2. Executar `~/.dotfiles/bin/dotfiles` sem flags interativos
3. Verificar que esses paths existem após install:
   - ~/bin (symlink ou dir)
   - ~/.commonrc (symlink)
   - ~/.vimrc (symlink)
4. Verificar que $PATH contém ~/.dotfiles/bin
5. Rodar `source ~/.commonrc` sem erros (exit 0)
6. Imprimir PASS ou FAIL com causa

Adicione ao repositório um Makefile target:
  smoke-test:
    docker build -f test/docker/Dockerfile.ubuntu -t dotfiles-smoke .
    docker run --rm dotfiles-smoke

Restrições:
- Não modifique bin/dotfiles para este teste
- O container não tem acesso à rede durante o teste
- Não use volumes que montem ~/.dotfiles do host

Critério de pronto: `make smoke-test` sai com código 0.
```

---

## 11. Testar portabilidade macOS vs Ubuntu

```
Vários source files assumem comportamentos específicos do
macOS ou do bash versão do macOS (3.2). Quero uma auditoria
de portabilidade.

Analise todos os arquivos em:
  ~/.dotfiles/source/*.sh
  ~/.dotfiles/bin/dotfiles
  ~/.dotfiles/init/*.sh

Para cada arquivo, identifique e reporte numa tabela markdown:

| Arquivo | Linha | Código | Problema | Portável? | Fix |
|---------|-------|--------|----------|-----------|-----|

Categorias de problema:
- "macOS only": usa `stat -f`, `pbcopy`, `open`, `osascript`,
  `brew`, `/usr/local`, `launchctl` sem `is_osx` guard
- "Linux only": usa `/proc`, `apt-get`, `systemctl`,
  `update-alternatives` sem `is_linux` guard
- "bash <4": usa `${!var[@]}`, `declare -A`, `mapfile`
  sem verificar versão do bash
- "path hardcoded": absoluto sem $HOME/$DOTFILES
- "command assume": usa `nmap`, `jq`, `aws`, `docker` sem
  checar se disponível (`command -v` / `pinpoint`)

Para cada achado "macOS only" ou "Linux only" SEM guard:
- Verifique se o arquivo inteiro já tem um `is_osx || return 1`
  no início — se sim, não é problema.

Não corrija — só audite. Saída: tabela markdown completa.
```

---

## 12. Testar o `claude_timer.sh` com entradas edge-case

```
~/.dotfiles/scripts/claude_timer.sh lê dois state files e
calcula um countdown. Quero testes que cubram edge cases.

Crie test/claude_timer.bats com os seguintes cenários:

1. Arquivo /tmp/claude_start não existe:
   - Script cria o arquivo com timestamp atual
   - Output contém "05h00m" (≈ 5h restantes)

2. /tmp/claude_start contém valor válido (NOW - 3600):
   - Remaining deve ser ≈ 4h00m (com tolerância de ±5s)

3. /tmp/claude_start contém valor stale (NOW - 99999):
   - Remaining deve ser "00h00m" (não negativo)
   - Script NÃO deve escrever em stderr

4. /tmp/claude_start contém conteúdo inválido ("abc\n"):
   - Script ignora e recria como novo timer
   - Output é "05h00m"

5. /tmp/claude_usage contém "75":
   - Output contém "75%"

6. /tmp/claude_usage contém "101" (fora de range):
   - % é ignorado, output não contém "%"

7. /tmp/claude_usage contém "não-número":
   - idem ao caso 6

Para cada teste: mocke os state files em $BATS_TMPDIR e
use a variável TIMER_FILE / USAGE_FILE se o script as
exportar. Se o script usar paths hardcoded (/tmp/), ajuste
o script para aceitar TIMER_FILE e USAGE_FILE como overrides
de ambiente antes de escrever os testes.

Critério de pronto: `bats test/claude_timer.bats` zero falhas.
```

---

## 13. Shellcheck completo em todos os scripts próprios

```
Quero rodar shellcheck em TODOS os arquivos shell do repo
que são código próprio (excluindo submódulos e vendor).

Execute:

  find ~/.dotfiles \
    -not -path '*/.git/*' \
    -not -path '*/vendor/*' \
    -not -path '*/link/.oh-my-zsh/*' \
    -not -path '*/link/.vim/plugged/*' \
    -not -path '*/link/.vim/autoload/plug.vim' \
    -not -path '*/link/.tmux/*' \
    \( -name "*.sh" -o -name "*.bash" \) \
    | sort \
    | xargs shellcheck -x -S warning 2>&1

Também cheque arquivos sem extensão com shebang shell:

  grep -rl "^#!/.*\(ba\)\?sh" ~/.dotfiles/bin \
    --exclude-dir=.git \
    | xargs shellcheck -x -S warning 2>&1

Para cada achado do shellcheck:
1. Agrupe por código de erro (SC2034, SC2086, etc.)
2. Mostre frequência: "SC2086: 12 ocorrências em 5 arquivos"
3. Para os 5 códigos mais frequentes, mostre o fix recomendado
   com exemplo antes/depois

NÃO aplique patches automaticamente — só reporte.
Crie o relatório em ~/.dotfiles/docs/SHELLCHECK.md.

Critério de pronto: relatório criado com todas as ocorrências
catalogadas e os 5 top fixes propostos.
```

---

## 14. Audit de quoting — variáveis sem aspas

```
Variáveis sem aspas causam word-splitting silencioso.
Quero um audit focado apenas nesse problema.

Execute nos arquivos próprios do repo (excluindo submódulos):

  shellcheck -x -e SC1090,SC1091,SC2148 \
    -f gcc ~/.dotfiles/source/*.sh \
    ~/.dotfiles/init/*.sh \
    ~/.dotfiles/bin/dotfiles \
    2>&1 | grep "SC2086\|SC2046\|SC2068\|SC2116" | sort -t: -k1,2

SC2086 = variável sem aspas duplas (word-split risk)
SC2046 = subshell sem aspas
SC2068 = array expansion sem aspas
SC2116 = echo desnecessário

Para cada arquivo com > 3 ocorrências de SC2086:
1. Liste as linhas problemáticas
2. Escreva o patch (diff -u) com as aspas adicionadas
3. Indique se a variável pode ter espaços em runtime
   (risco real) ou é sempre um path simples (baixo risco)

Aplique apenas os patches de risco real (espaços possíveis).
Faça um commit por arquivo:
  fix(<arquivo>): adicionar aspas em variaveis (SC2086)

Critério de pronto: re-rodar shellcheck não retorna SC2086
nos arquivos source/ e init/.
```

---

## 15. Verificar `set -euo pipefail` / error handling

```
Scripts de instalação em ~/.dotfiles/init/ deveriam falhar
rápido em erros. Verifique se error handling está correto.

Para cada arquivo em ~/.dotfiles/init/*.sh:

1. Tem `set -e` ou `set -euo pipefail` no início?
   - Se não, é problema — `apt-get install` silencioso pode
     passar mesmo falhando
2. Usa `|| return 1` ou `|| exit 1` consistentemente em
   comandos críticos?
3. Tem traps de limpeza para arquivos temporários?
   (`trap 'rm -f $tmpfile' EXIT`)
4. Usa `command -v tool >/dev/null 2>&1 || { ... ; return; }`
   antes de chamar ferramentas não-garantidas?

Reporte numa tabela:
| Arquivo | set -e | Error guards | Trap EXIT | Rating |
Rating: ✅ OK / ⚠️ Parcial / ❌ Ausente

Para os arquivos ❌, proponha o patch mínimo para adicionar
`set -euo pipefail` e um trap de saída seguro.

NÃO aplique — só reporte e proponha.

Critério de pronto: tabela completa com rating e proposta
de patch para cada ❌.
```

---

## 16. Inventário e deduplicação de aliases

```
Os dotfiles definem aliases em vários arquivos. Quero um
inventário completo para encontrar duplicatas e conflitos.

Execute:

  grep -rh "^alias " ~/.dotfiles/source/ ~/.dotfiles/link/.commonrc \
    | sort > /tmp/all_aliases.txt
  cat /tmp/all_aliases.txt

Analise o output e reporte:

1. **Duplicatas exatas**: mesmo alias definido duas vezes
   com mesmo valor — listar e indicar onde remover
2. **Conflitos**: mesmo alias com valores diferentes —
   qual arquivo vence (source order)?
3. **Sombras de builtin/comando**: aliases que sobrescrevem
   `ls`, `grep`, `cat`, `diff`, `find` — listar com o valor
   (pode ser intencional, verificar)
4. **Aliases obsoletos**: apontam para ferramentas que
   provavelmente não existem mais (bower, grunt, gulp, svn,
   vagrant, etc.)
5. **Aliases não usados**: definem algo que não foi invocado
   nos últimos 90 dias (verifique `~/.zsh_history` ou
   `~/.bash_history` se disponível)

Output: markdown com uma seção por categoria, lista de
aliases afetados com arquivo:linha de origem.

Não modifique nada. Critério de pronto: relatório completo
sem modificações no repo.
```

---

## 17. Inventário de funções exportadas e conflitos de nome

```
Os dotfiles definem dezenas de funções shell que ficam
disponíveis em toda sessão. Quero auditar conflitos e
funções que sobrescrevem comandos do sistema.

Execute:

  grep -rh "^function \|^[a-zA-Z_][a-zA-Z0-9_-]*() {" \
    ~/.dotfiles/source/*.sh \
    ~/.dotfiles/link/.commonrc \
    | grep -oE "^function [^ ()]+" \
    | sed 's/^function //' \
    | sort > /tmp/all_functions.txt

Analise:

1. **Funções que sobrescrevem comandos do PATH**:
     while read -r fn; do type -a "$fn" 2>/dev/null | grep -v "function"; done \
       < /tmp/all_functions.txt
   Identifique onde o dotfiles define `git`, `ssh`, `diff`,
   `scp`, `grep`, etc. Isso é intencional? Documente.

2. **Funções com nomes iguais definidas em arquivos diferentes**:
   duplicatas onde o arquivo carregado por último vence.

3. **Funções que dependem de outras funções do dotfiles**:
   (chamam algo que só existe se o dotfiles estiver carregado)
   — podem quebrar em ambiente limpo.

4. **Funções que usam variáveis globais não documentadas**:
   verificar $DOTFILES, $CORE, $GOPATH, $ANDROID_HOME —
   se não definidas, o comportamento é imprevisível.

Output: relatório markdown com as 4 seções.
```

---

## 18. Revisar ordem de carregamento dos source files

```
Os arquivos em ~/.dotfiles/source/ são carregados em ordem
alfabética (00_, 10_, 50_...). Quero verificar se a ordem
atual é correta e não há dependências quebradas.

Construa o grafo de dependências:

1. Para cada arquivo source/NN_nome.sh, liste quais funções/
   variáveis ele define (grep "^function\|^export\|^alias")
2. Liste o que cada arquivo consome (variáveis e funções
   chamadas que não são definidas no próprio arquivo)
3. Para cada consumo: qual arquivo o define?
   Esse arquivo é carregado ANTES? Se não → dependência invertida.

Cheque especificamente:
- `$DOTFILES` é usado antes de ser definido?
  (É definido em link/.commonrc ANTES dos source files)
- `path_remove` é chamada em 01_path.sh — onde é definida?
- `is_osx`, `is_linux`, `pinpoint` — onde são definidas?
  São usadas antes disso?
- `e_header`, `e_error` — usadas em init/ mas definidas em
  bin/dotfiles — init scripts as têm disponíveis?

Reporte numa tabela:
| Consumidor | Variável/função | Definida em | Carregada antes? |

Critério de pronto: tabela completa, dependências invertidas
destacadas com ⚠️.
```

---

## 19. Refatorar detecção de OS em `bin/dotfiles`

```
~/.dotfiles/bin/dotfiles tem uma hierarquia de funções de
detecção de OS (is_osx, is_linux, is_debian, is_ubuntu, etc.)
que é duplicada ou referenciada em vários source files.

Analise a implementação atual (linhas ~76-160 de bin/dotfiles)
e reporte:

1. **Completude**: os casos cobertos (osx, debian, ubuntu,
   kali, redhat, archlinux, windows) são suficientes para
   2025? Faltam: Alpine, Fedora, openSUSE, Raspberry Pi OS?

2. **Corretude**: cada função usa o método correto para
   detecção:
   - macOS: `$OSTYPE =~ ^darwin` — correto
   - Ubuntu: usa `lsb_release`? verifica `/etc/lsb-release`?
   - Debian: verifica `/etc/debian_version`?
   - Kali: como distingue de Debian?
   - `is_linux`: só retorna true se uma das subfunções bate
     — e Alpine? WSL? — falso negativo?

3. **Consistência**: é usado `return 0`/`return 1` em todas?
   Alguma usa `exit` por engano?

4. **Performance**: alguma função faz I/O em disco ou chama
   processos externos toda vez que é invocada? Propor cache
   com variável global `_IS_OSX` etc.

Proponha a versão refatorada (diff) com:
- Suporte a Alpine e WSL
- Cache por variável global
- Testes unitários (bats) para cada `is_*`

Não aplique sem confirmação.
```

---

## 20. Revisão do `.gitconfig` — configs obsoletas ou inseguras

```
Revise ~/.dotfiles/copy/.gitconfig (ou link/.gitconfig se
existir) identificando:

1. **Configs obsoletas**: seções para ferramentas removidas
   do workflow (svn bridge, cvs, hg), versões antigas de
   protocolos, etc.

2. **Configs inseguras**:
   - `credential.helper` — está usando store (plaintext)?
   - `http.sslVerify = false` — existe?
   - `safe.directory = *` — existe? É necessário?
   - Qualquer `url."git://"` rewrite para protocolo sem TLS

3. **Configs que deveriam ser locais** (não commitadas):
   - `user.email`, `user.signingkey`, `core.sshCommand`
     com path específico do host

4. **Oportunidades de melhoria 2025**:
   - `init.defaultBranch = main`?
   - `pull.rebase = true`?
   - `fetch.prune = true`?
   - `rebase.autoStash = true`?
   - `diff.algorithm = histogram`?
   - `merge.conflictstyle = zdiff3`?

Reporte em markdown com 4 seções. Para cada melhoria, mostre
o snippet de config a adicionar.

Critério de pronto: relatório completo sem modificar arquivos.
```

---

## 21. Audit de `eval` em `bin/dotfiles` (análise detalhada)

```
~/.dotfiles/bin/dotfiles contém avaliações via `eval` nas
linhas aproximadas 232, 259, 268, 284, 378 (verifique as
linhas atuais com: grep -n "eval" ~/.dotfiles/bin/dotfiles).

Para cada ocorrência:

1. Copie o trecho (5 linhas de contexto)
2. Identifique o propósito: referência indireta a array?
   construção dinâmica de comando? outro?
3. Classifique a entrada:
   - "hardcoded": string literal no próprio script → baixo risco
   - "interna": variável setada pelo próprio script, não exposta → baixo risco
   - "semi-externa": nome de array vem de argumento de função → médio risco
   - "externa": pode vir de env, arquivo, ou stdin → alto risco
4. Para as classificadas "médio" ou "alto":
   - Bash 4.3+ suporta `declare -n` (nameref) — mostra a
     refatoração equivalente sem eval
   - Bash <4.3: alternativa com ${!varname} para leitura

Mostre um diff completo para cada ocorrência com solução
proposta. Não aplique — apenas analise.

Resultado esperado: markdown com uma seção por eval, análise
de risco e diff de refatoração.
```

---

## 22. Verificar exposição de secrets em arquivos rastreados

```
Verifique se há credenciais, tokens, chaves ou informações
sensíveis nos arquivos commitados no repo
~/.dotfiles (excluindo .git/).

Execute as seguintes buscas:

1. Padrões de secret conhecidos:
   grep -rn \
     -e "AKIA[0-9A-Z]{16}" \
     -e "ghp_[a-zA-Z0-9]{36}" \
     -e "-----BEGIN.*PRIVATE KEY-----" \
     -e "password\s*=\s*['\"][^'\"]\+" \
     -e "api[_-]key\s*=\s*['\"][^'\"]\+" \
     -e "token\s*=\s*['\"][^'\"]\+" \
     --include="*.sh" --include="*.conf" \
     --include="*.local" --include="*.cfg" \
     --exclude-dir=.git --exclude-dir=vendor \
     ~/.dotfiles

2. Endereços de email e usernames hardcoded:
   grep -rn "sierra\|ricardosierra\|sierra.csi" \
     ~/.dotfiles \
     --exclude-dir=.git \
     --exclude-dir=docs \
     --exclude-dir="link/.oh-my-zsh" \
     --exclude-dir="link/.vim/plugged"

3. IPs e hostnames internos:
   grep -rEn "([0-9]{1,3}\.){3}[0-9]{1,3}" \
     ~/.dotfiles/source ~/.dotfiles/init \
     --include="*.sh"

4. Verifique o histórico git para secrets removidos:
   git -C ~/.dotfiles log --all -p \
     | grep -E "password|secret|token|key" \
     | grep "^+" | grep -v "^+++" | head -50

Reporte cada achado com arquivo, linha, conteúdo (mascarado
se real) e recomendação (mover para .dotfilesconfig.local,
usar env var, etc.).
```

---

## 23. Audit de `curl | bash` e downloads não verificados

```
Instaladores modernos frequentemente usam curl | bash.
Quero auditar o uso dessa prática nos init scripts.

Busque todas as ocorrências:

  grep -rn "curl.*|.*bash\|wget.*|.*bash\|curl.*|.*sh\b" \
    ~/.dotfiles/init/ ~/.dotfiles/bin/dotfiles \
    --include="*.sh"

Para cada ocorrência:
1. Identifique a URL de download
2. A URL usa HTTPS? Se não, é risco de MITM
3. Há verificação de checksum após o download? Se não, risco
4. A URL é de um domínio oficial do projeto?
   (raw.githubusercontent.com, releases.hashicorp.com, etc.)
5. O script baixado é salvo para inspeção antes de executar?

Adicionalmente, busque downloads diretos:
  grep -rn "curl -o\|wget -O\|curl -fsSL" \
    ~/.dotfiles/init/ --include="*.sh"

Para downloads sem verificação de integridade, proponha a
alternativa com checksum:
  curl -fsSL $URL -o /tmp/installer.sh
  echo "$SHA256  /tmp/installer.sh" | sha256sum --check
  bash /tmp/installer.sh

Reporte: tabela com cada download, risk rating e proposta.
```

---

## 24. Revisão de permissões de arquivos em `copy/`

```
O diretório ~/.dotfiles/copy/ contém arquivos copiados
verbatim para $HOME, incluindo potencialmente configs com
dados sensíveis.

Verifique:

1. Permissões dos arquivos no repo:
   find ~/.dotfiles/copy -type f | xargs ls -la

2. Algum arquivo em copy/ deveria ter permissão 600 mas
   está como 644? (ex: .ssh/config, .netrc, .gnupg)

3. Algum arquivo em copy/ contém dados que deveriam estar
   em .gitignore ao invés de commitados?
   (verifique: cat ~/.dotfiles/copy/.dotfilesconfig.local
    e outros arquivos .local)

4. Compare com o .gitignore do repo — copy/*.local está
   ignorado? Se não, verificar se o conteúdo é seguro.

5. Verifique se o script bin/dotfiles seta permissões
   corretas ao copiar os arquivos para $HOME:
   grep -n "chmod\|permission\|700\|600" \
     ~/.dotfiles/bin/dotfiles

Reporte problemas encontrados com recomendação para cada um.
```

---

## 25. Medir e otimizar tempo de carregamento do shell

```
Shells lentos degradam a experiência de desenvolvimento.
Quero medir e otimizar o tempo de carregamento do zsh com
os dotfiles.

1. Meça o tempo atual de 5 execuções:
   for i in {1..5}; do
     time zsh --no-rcs -i -c "source ~/.zshrc; exit" 2>&1
   done
   Calcule a média.

2. Identifique os bottlenecks com zsh profiling:
   # Adicione ao início do ~/.zshrc temporariamente:
   zmodload zsh/zprof
   # Adicione ao final:
   zprof > /tmp/zprof_output.txt
   # Execute: zsh -i -c exit; cat /tmp/zprof_output.txt

3. Identifique os source files mais lentos:
   for f in ~/.dotfiles/source/*.sh; do
     t=$( { time source "$f"; } 2>&1 | grep real )
     echo "$t $f"
   done | sort -k2 -n -r | head -10

4. Para cada source file > 50ms:
   - Identifique o comando lento (subshell? `which`? `git`?)
   - Proponha lazy loading ou cache

5. Targets de otimização conhecidos:
   - `rbenv init` — lazy load
   - `nvm` (se presente) — lazy load com function wrapper
   - Qualquer `git` call no prompt ou no source

Relatório esperado: tabela de tempos + top 5 otimizações
com patch proposto. Não aplique sem confirmação.
```

---

## 26. Lazy loading de tools pesados (rbenv, nvm, pyenv)

```
Ferramentas como rbenv, nvm, pyenv e sdkman adicionam 100-
500ms ao tempo de carregamento do shell. Quero implementar
lazy loading para todas elas.

Em ~/.dotfiles/source/50_ruby.sh e outros source files,
substitua inicializações eagerly loaded por funções de
lazy load usando o padrão:

  # Ao invés de: eval "$(rbenv init -)"
  # Use:
  rbenv() {
    unfunction rbenv  # zsh
    eval "$(command rbenv init -)"
    rbenv "$@"
  }

Implemente lazy loading para:

1. **rbenv** (source/50_ruby.sh):
   - `rbenv init` só roda na primeira invocação de `rbenv`
   - Aliases `ruby`, `gem`, `bundle` também devem triggerar

2. **nvm** (se existir source/50_node.sh):
   - `nvm load` ao primeiro uso de `nvm`, `node`, `npm`, `npx`

3. **pyenv** (se existir source/50_python.sh):
   - Idem para `python`, `pip`, `python3`

4. **Go tools** (source/01_path.sh):
   - $GOPATH/bin no PATH é suficiente — não há init pesado,
     mas verificar se tem `go env` sendo chamado no source

Para cada implementação:
- O lazy load deve funcionar em bash e zsh
- Mostrar mensagem de carregamento na primeira vez? (opcional,
  deixar comentado)
- Medir tempo antes/depois

Critério de pronto: `time zsh -i -c exit` melhora pelo menos
200ms em relação ao baseline medido no prompt #25.
```

---

## 27. Eliminar subshells desnecessários no prompt

```
Subshells no PROMPT_COMMAND ou $PS1 são executados a cada
prompt — se lentos, causam lag visível.

Analise os arquivos de prompt em ~/.dotfiles/source/:

1. Encontre onde PS1/PROMPT/RPROMPT são definidos:
   grep -rn "PS1\|PROMPT\|RPROMPT\|precmd\|PROMPT_COMMAND" \
     ~/.dotfiles/source/

2. Para cada $(comando) dentro do prompt:
   - Quanto tempo leva? (use `time $(comando)`)
   - Pode ser substituído por variável atualizada em
     `precmd()` / `PROMPT_COMMAND` ao invés de subshell
     inline?
   - Pode ser cacheado por N segundos?

3. Cheque especificamente:
   - Chamadas `git branch`, `git status` no prompt — essas
     devem usar async (zsh-async, gitstatus) ou cache
   - `$(pwd)` — usar $PWD nativo ao invés de subshell
   - `$(hostname)` — usar $HOSTNAME já disponível
   - `$(date)` — usar zsh $EPOCHSECONDS se disponível

4. Se o prompt usa oh-my-zsh, identifique quais plugins
   contribuem para lentidão do prompt (vcs_info, git status)
   e proponha async_prompt ou powerlevel10k como alternativa.

Relatório: lista de subshells com tempo e proposta de fix.
```

---

## 28. Revisão completa do `.vimrc` — plugins obsoletos

```
~/.dotfiles/link/.vimrc referencia plugins instalados via
vim-plug. Muitos podem estar obsoletos ou substituídos.

Para cada Plug '...' no .vimrc:

1. Verifique se o repositório GitHub ainda existe e tem
   commits nos últimos 2 anos (use: gh repo view <user/repo>
   ou curl -s https://api.github.com/repos/<user/repo>)

2. Identifique plugins com substitutos modernos:
   - vim-syntastic/syntastic → w0rp/ale (já presente!)
   - Plug 'klen/python-mode' → desatualizado, substituir
     por null-ls ou vim-lsp + pyright
   - Plug 'terryma/vim-multiple-cursors' → archivado em 2022,
     substituir por mg979/vim-visual-multi
   - Plug 'vim-scripts/dbext.vim' → último commit 2015
   - Plug 'chase/vim-ansible-yaml' → desatualizado

3. Identifique duplicações de funcionalidade:
   - vim-syntastic E ale estão ambos — apenas um deve estar ativo
   - CtrlP E FZF? Escolher um

4. Para cada plugin a remover: mostrar as configurações
   associadas que também devem ser removidas

Output: tabela | Plugin | Status | Recomendação | Linhas |
```

---

## 29. Revisão do `.tmux.conf` — modernizar para tmux 3.x

```
Revise ~/.dotfiles/link/.tmux.conf para compatibilidade e
boas práticas com tmux 3.3+.

1. **Opções removidas em tmux 3.x**:
   Cheque se usa opções depreciadas:
   tmux show-options -g 2>&1 | grep "unknown option"
   Comuns: `status-utf8`, `utf8`, `terminal-overrides` (sintaxe mudou)

2. **Prefixo**: ainda usa Ctrl-b ou já mudou para Ctrl-a?
   Se Ctrl-b, documentar por que (pode ser intencional)

3. **Mouse**: `set -g mouse on` substitui as 4 linhas de
   mouse legacy — verificar se foi modernizado

4. **True color**: tem `set -g default-terminal "tmux-256color"`
   e `set -ga terminal-overrides ",*256col*:Tc"`?
   Sem isso, neovim/vim ficam sem true color

5. **Status bar**: usa `status-interval 60`?
   A `claude_timer.sh` depende disso — verificar

6. **Plugins**: os plugins via tpm são necessários?
   Listar o que cada plugin faz e se o tmux 3.x já inclui
   nativamente

7. **Bindings conflitantes**: algum binding conflita com
   vim-tmux-navigator? (C-h, C-j, C-k, C-l)

Output: relatório com cada item + diff proposto para
modernização. Não modifique sem confirmação.
```

---

## 30. Revisão de keybindings do vim — conflitos e sobreposições

```
O ~/.dotfiles/link/.vimrc define dezenas de mappings.
Quero um audit de conflitos, sobreposições e inconsistências.

1. **Extraia todos os mappings definidos**:
   grep -n "^\s*[nvxiocl]\?map\|^\s*[nvxiocl]\?noremap" \
     ~/.dotfiles/link/.vimrc \
     | sort -t: -k2

2. **Identifique conflitos** (mesmo LHS mapeado mais de uma vez):
   - Qual modo (n, v, i, etc.)?
   - Qual definição vence (a última no arquivo)?
   - É intencional (override de plugin)?

3. **Identifique mapeamentos de letras simples em normal mode**:
   `map j`, `map k`, `map q`, etc. — interferem com
   movimentos padrão do vim. Listar todos.

4. **Verifique o mapeamento de <C-J>**:
   - Linha ~234: `nnoremap <C-J> i<CR><Esc>k:.s/\s\+$//e<CR>j^`
   - Linha ~203: `nnoremap <silent> <C-J> :TmuxNavigateLeft<cr>`
   → Conflito direto! Qual vence?

5. **Mapeamentos que shadoweiam comandos built-in úteis**:
   `map q: :q` — desabilita o histórico de comandos do vim

6. **Leader duplicado**: verifica se `<leader>b`, `<leader>n`,
   etc. são definidos mais de uma vez para ações diferentes

Output: relatório markdown com as 6 seções e ação proposta
para cada conflito.
```

---

## 31. Revisão do `.zshrc` / `link/.commonrc`

```
Revise ~/.dotfiles/link/.commonrc e ~/.dotfiles/link/.zshrc
(se existir) identificando:

1. **Variáveis de ambiente redundantes**: definidas aqui E
   em source/*.sh — qual tem precedência?

2. **Compatibilidade bash/zsh**: .commonrc é sourced em ambos.
   Identifique constructs que são zsh-only ou bash-only:
   - `setopt`, `zstyle`, `autoload` → zsh only
   - `shopt`, `complete -F` → bash only
   Envolva em guards: `if [ -n "$ZSH_VERSION" ]; then`

3. **Carregamento condicional de arquivos** (~/.aliases,
   ~/.exports, ~/.path no loop de for):
   - Esses arquivos existem no repo? São gerados?
   - Se não existirem, o loop é silencioso mas inútil

4. **DEV_FOLDER logic**: a verificação de `/sierra/Dev`
   ainda é necessária? Há alguma máquina onde esse path
   existe?

5. **`lesspipe` / `lessopen`**: a linha
   `[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"`
   é segura em zsh? `eval` com output de comando externo.

6. **`debian_chroot`**: a lógica de chroot no .commonrc —
   é usada? Há algum caso de uso atual?

Reporte: lista de problemas com arquivo:linha e proposta.
```

---

## 32. Dependências externas — o que o dotfiles assume instalado

```
Os dotfiles assumem a presença de vários tools externos sem
verificar se existem. Quero um inventário completo.

Execute:

  grep -rh "^\s*\(command\|pinpoint\|which\|type\) " \
    ~/.dotfiles/source/*.sh \
    | grep -v ">/dev/null\|2>&1\|command -v" \
    | head -50

  # Também: tools chamados diretamente sem check:
  grep -rhn "\bjq\b\|\bnmap\b\|\bdirb\b\|\baws\b\|\bdocker\b\
\|\bgit\b\|\bcurl\b\|\bwget\b\|\bnode\b\|\bpython3\b\
\|\bgo\b\|\brbenv\b\|\bpyenv\b" \
    ~/.dotfiles/source/*.sh \
    | grep -v "^#\|is_osx\|command -v"

Para cada tool identificado:
1. É verificado antes do uso com `command -v` / `pinpoint`?
2. É instalado pelos init scripts? Em qual?
3. Se não instalado e não verificado: a função deve adicionar
   um guard `command -v tool >/dev/null || { echo "..."; return; }`

Crie uma tabela:
| Tool | Usado em | Instalado por | Guard? | Ação |

Critério de pronto: tabela completa.
```

---

## 33. Revisar copy/ vs link/ — o que deve mudar de categoria

```
~/.dotfiles/copy/ contém arquivos copiados (não symlinkados)
para $HOME. A justificativa é que têm dados pessoais.
~/.dotfiles/link/ contém arquivos symlinkados (editar em
qualquer lugar reflete imediatamente).

Revise se a categorização atual está correta:

1. **Listar arquivos em copy/**:
   ls -la ~/.dotfiles/copy/
   Para cada um: tem dados realmente pessoais (email, host,
   senha) ou é config genérica que poderia ser symlinkada?

2. **Listar arquivos em link/ que têm dados pessoais**:
   grep -l "sierra\|@gmail\|rds.bocoup\|skillsbot" \
     ~/.dotfiles/link/.* 2>/dev/null
   Esses deveriam estar em copy/ ao invés de link/!

3. **Identificar dados sensíveis em link/.vimrc**:
   grep -n "rds.bocoup\|skillsbot\|password\|token" \
     ~/.dotfiles/link/.vimrc
   (Há `let g:dbext_default_profile_PG_skillsbot` no .vimrc
   com hostname e dbname — deve ser movido para copy/ ou
   gitignored)

4. **Propor uma lista de movimentações**:
   - Arquivo X: mover de link/ para copy/
   - Arquivo Y: pode ser movido de copy/ para link/ (sem dados)

Não mova nada sem confirmação. Output: relatório com proposta.
```

---

## 34. Atualizar docs/ para refletir correções recentes

```
Em 2026-05-03 foram aplicadas correções significativas no
repo ~/.dotfiles (commit dd1d301). A documentação em
docs/REVIEW.md e docs/REVIEW2.md pode estar desatualizada.

1. Leia o diff completo do commit de correção:
   git -C ~/.dotfiles show dd1d301 --stat
   git -C ~/.dotfiles show dd1d301

2. Para cada arquivo em docs/REVIEW.md e docs/REVIEW2.md:
   - Identifique achados que foram resolvidos pelo commit
   - Marque-os como resolvidos (ex: adicionar "(✅ Resolvido
     em dd1d301 2026-05-03)" ao final da linha do achado)
   - Não remova — mantenha como histórico

3. Verifique se REVIEW.md menciona os bugs B1, B2, SRC-01,
   SRC-02, SRC-03, INIT-02, ORCH-01 do CLAUDE.md:
   - B2 (hardcoded /Users/sierra) → resolvido
   - SRC-01 (ssh/git/scp shadowing) → resolvido
   - SRC-03 ($HOME~/.local) → resolvido
   - INIT-02 (continue fora de loop) → resolvido
   Marque cada um.

4. Atualize o CHANGELOG.md (formato Release Notes com emojis)
   adicionando os fixes do commit dd1d301 na seção v0.5.x
   ou Unreleased.

Faça um único commit:
  docs: marcar achados resolvidos em REVIEW.md e REVIEW2.md

Critério de pronto: nenhum achado já resolvido aparece sem
a marcação "✅ Resolvido".
```

---

## 35. Criar Brewfile centralizado a partir dos init scripts

```
Os init scripts em ~/.dotfiles/init/30_osx_homebrew_recipes.sh
e similares instalam recipes individualmente. Homebrew Bundle
permite declarar tudo em um Brewfile e instalar com
`brew bundle`.

1. Extraia todos os `brew install`, `brew tap`, `brew cask`
   dos init scripts:
   grep -rn "brew install\|brew tap\|brew cask\|mas install" \
     ~/.dotfiles/init/ --include="*.sh"

2. Gere um ~/.dotfiles/Brewfile com o formato correto:
   tap "homebrew/cask"
   brew "git"
   brew "shellcheck"
   cask "iterm2"
   mas "Xcode", id: 497799835

3. Agrupe por categoria com comentários:
   # --- Shell Tools ---
   # --- Dev Tools ---
   # --- Security ---
   # --- Cloud ---
   # --- Casks ---
   # --- Mac App Store ---

4. Adicione ao Brewfile apenas recipes que existem
   atualmente no Homebrew (verifique: `brew info <name>`).
   Recipes descontinuadas devem aparecer como comentário.

5. Adicione ao bin/dotfiles ou ao init/20_osx_homebrew.sh
   uma chamada `brew bundle --file="$DOTFILES/Brewfile"`
   com guard `is_osx`.

Critério de pronto: `brew bundle check --file=~/.dotfiles/Brewfile`
passa (todas as dependências instaladas ou disponíveis).
```

---

## 36. Substituir plugins vim deprecated no `.vimrc`

```
Vários plugins no ~/.dotfiles/link/.vimrc estão arquivados
ou sem manutenção. Quero substituir os mais críticos.

Substitua os seguintes (um de cada vez, com commit separado):

1. **terryma/vim-multiple-cursors** (arquivado 2022):
   Substitua por `mg979/vim-visual-multi`.
   - Remova as configurações do plugin antigo (linhas com
     multi_cursor_*)
   - Adicione as configurações do novo plugin
   - Mapeamentos devem ser equivalentes

2. **klen/python-mode** (desatualizado):
   Substitua por null-ls com pyright ou apenas `dense-analysis/ale`
   que já está instalado. Python-mode faz tudo que ale já faz.
   - Verifique se há configurações de python-mode únicas
     (g:pymode_*) que não têm equivalente em ale

3. **vim-scripts/dbext.vim** (último commit 2015):
   Verifique se há alternativa ou se pode ser removido
   sem perda de funcionalidade usada ativamente.

Para cada substituição:
- Mostre o diff no .vimrc (add/remove Plug + configs)
- Confirme que a funcionalidade equivalente existe
- Adicione comentário de migração

Faça um commit por substituição.
Critério de pronto: `:PlugInstall` e `:PlugClean` sem erros.
```

---

## 37. Avaliar migração de oh-my-zsh para alternativa mais leve

```
~/.dotfiles/link/.oh-my-zsh é um submódulo de oh-my-zsh.
Em 2025, há alternativas mais rápidas e minimalistas.

Faça uma análise comparativa, SEM migrar:

1. **Medir o custo atual do oh-my-zsh**:
   time zsh --no-rcs -c "
     export ZSH=~/.oh-my-zsh
     source \$ZSH/oh-my-zsh.sh
     exit
   "
   Compare com `time zsh --no-rcs -c exit` (shell vazio)

2. **Inventariar o que é usado do oh-my-zsh**:
   - Quais plugins estão listados em $plugins?
     (cheque link/.zshrc ou source/*.sh)
   - O theme usado é do oh-my-zsh ou customizado?
   - Quais funções do oh-my-zsh são chamadas diretamente
     nos source files?

3. **Alternativas a avaliar**:
   - **Prezto**: mais rápido, menos mágico
   - **Zinit**: lazy loading nativo, compatível com plugins oh-my-zsh
   - **Sheldon**: Rust-based, declarativo (TOML)
   - **Nenhuma**: apenas zsh puro com plugins manuais

4. Para cada alternativa: mostrar o que seria necessário
   mudar nos source files.

5. **Recomendação**: qual alternativa melhor equilibra
   velocidade, compatibilidade com plugins existentes e
   esforço de migração?

Output: relatório comparativo com benchmarks e recomendação.
Não migre sem confirmação.
```

---

## 38. Modernizar syntax bash 3 → bash 4/5 nos scripts

```
macOS inclui bash 3.2 por limitações de licença (GPL v2).
Mas em Linux e com Homebrew no mac, bash 5.x está disponível.
Os scripts usam constructs de bash 3.2 que poderiam ser
modernizados.

Analise ~/.dotfiles/source/*.sh e ~/.dotfiles/bin/dotfiles:

1. **Substituições diretas (seguras, retrocompat)**:
   - `` `backtick` `` → `$(subshell)` (mais legível)
   - `[ ]` → `[[ ]]` onde não há necessidade de POSIX
   - `echo -e` → `printf` (mais portável)
   - `\`seq 1 N\`` → `{1..N}` (bash 3+ suporta)

2. **Melhorias bash 4+ (verificar versão antes)**:
   - `declare -A` para arrays associativos
   - `${var,,}` / `${var^^}` para lowercase/uppercase
     (ao invés de `tr '[:upper:]' '[:lower:]'`)
   - `mapfile` / `readarray` ao invés de while+read loops
   - `${!nameref}` para referência indireta (sem eval)

3. **Para cada ocorrência de backtick**:
   Mostre o arquivo:linha e a versão modernizada.

4. **Para cada `eval` que pode ser substituído por nameref**:
   Mostre o diff (requer bash 4.3+).

Critério: mostrar diff para cada mudança, separar em
"retrocompat" (seguro aplicar) e "bash4+" (requer guard).
```

---

## 39. Adicionar suporte a XDG Base Directory nos configs

```
O XDG Base Directory Specification define onde apps devem
guardar configs ($XDG_CONFIG_HOME), dados ($XDG_DATA_HOME),
cache ($XDG_CACHE_HOME) e runtime ($XDG_RUNTIME_DIR).

Verifique quais configs nos dotfiles já respeitam XDG e
quais ainda usam paths ~/.legados:

1. **Configs que deveriam usar XDG**:
   - vim: `~/.vim` → `$XDG_CONFIG_HOME/vim` (ou `$XDG_DATA_HOME/vim`)
   - git: `~/.gitconfig` → `$XDG_CONFIG_HOME/git/config`
   - tmux: `~/.tmux.conf` → `$XDG_CONFIG_HOME/tmux/tmux.conf`
   - bash history: `~/.bash_history` → `$XDG_STATE_HOME/bash/history`
   - zsh history: `~/.zsh_history` → `$XDG_STATE_HOME/zsh/history`

2. Para cada um: o programa suporta XDG nativamente?
   (vim com `--cmd "set rtp+=..."`, git com $GIT_CONFIG, etc.)

3. Em source/01_exports.sh (ou similar): os exports
   XDG_CONFIG_HOME, XDG_DATA_HOME, XDG_CACHE_HOME estão
   definidos? Se não, adicione com defaults corretos:
     export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
     export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
     export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

4. Proponha um plano de migração gradual: quais apps migrar
   primeiro (mais impacto, menor risco)?

Output: tabela de compatibilidade XDG + plano de migração.
Não aplique sem confirmação.
```

---

## 40. Criar comando `dotfiles doctor` para auto-diagnóstico

```
Quero adicionar um subcomando `dotfiles doctor` ao
~/.dotfiles/bin/dotfiles que verifica a saúde do ambiente.

O comando deve checar e reportar (✅/⚠️/❌):

1. **Dependências essenciais presentes**:
   git, curl, zsh, bash, vim (ou nvim), tmux

2. **Symlinks corretos**:
   Para cada arquivo em ~/.dotfiles/link/: o symlink em $HOME
   aponta para o arquivo correto e o target existe?

3. **Variáveis de ambiente obrigatórias**:
   $DOTFILES, $HOME, $SHELL estão definidas?
   $DOTFILES aponta para um diretório existente?

4. **Source files carregando sem erro**:
   Para cada source/NN_*.sh: `bash -n "$f"` (syntax check)
   passa?

5. **Submódulos up-to-date**:
   `git submodule status` — algum com prefixo `-` (não
   inicializado) ou `+` (modified)?

6. **Init scripts idempotentes** (check passivo):
   Verifica se as ferramentas instaladas pelos init scripts
   estão presentes (brew, git, etc.)

7. **Versão do bash e zsh**:
   Reporta versões e avisa se bash < 4 (macOS default)

Implementação:
- Adicione case "doctor") ao switch em bin/dotfiles
- Cada check é uma função check_X() que retorna 0 (ok) ou 1
- Output colorido usando e_success/e_error já disponíveis
- Exit code: 0 se tudo ok, 1 se qualquer check falhou

Critério de pronto: `dotfiles doctor` roda sem erros de
sintaxe e detecta corretamente um symlink quebrado quando
testado manualmente.
```

---

## 41. Adicionar tema/colorscheme consistente entre tmux, vim e shell

```
Quero que tmux, vim e o prompt do shell usem a mesma paleta
de cores (Gruvbox Dark, que já está configurado no .vimrc).

1. **Vim** (já configurado):
   ~/.dotfiles/link/.vimrc tem `colorscheme gruvbox`.
   Confirme que true color está habilitado:
   `set termguicolors` está no .vimrc?

2. **tmux**:
   ~/.dotfiles/link/.tmux.conf usa Gruvbox?
   Se não, adicione o tema Gruvbox para tmux:
   - Status bar: fundo #282828 (gruvbox bg), texto #ebdbb2
   - Janela ativa: #d79921 (gruvbox yellow)
   - Janela inativa: #504945 (gruvbox bg2)
   - Prefixo pressionado: #fb4934 (gruvbox red)

3. **Shell prompt** (zsh/bash):
   O PS1/PROMPT usa cores que fazem parte do Gruvbox?
   Se o prompt usa oh-my-zsh, o theme atual é compatível
   com Gruvbox?

4. **Terminal emulator** (iterm2 / alacritty / kitty):
   Há um arquivo de config para o terminal nos dotfiles?
   Se sim, adicione o profile Gruvbox Dark correspondente.

5. Consistência: garanta que `set -g default-terminal "tmux-256color"`
   e `set -ga terminal-overrides` com Tc flag estão no tmux.conf,
   para que vim use true color dentro do tmux.

Faça um commit por componente (tmux, shell prompt, terminal).
Critério de pronto: screenshot mostrando as 3 janelas com
paleta visualmente consistente.
```

---

## 42. Avaliar adoção de chezmoi ou dotbot para deploy

```
O sistema atual de deploy (bin/dotfiles) é um shell script
customizado. Ferramentas modernas como chezmoi e dotbot
oferecem funcionalidades como templates, diff interativo
e gerenciamento multi-máquina.

Faça uma análise de migração:

1. **Mapeie o que bin/dotfiles faz atualmente**:
   - Copia copy/ para $HOME
   - Symlink link/ para $HOME
   - Executa init/*.sh em ordem
   - Sourca source/*.sh

2. **Chezmoi**:
   - Como representaria copy/ (templates)?
   - Como representaria link/ (symlinks)?
   - Os init scripts continuariam como hooks?
   - Suporta múltiplas máquinas com configs diferentes?
   - Migração: `chezmoi import ~/.dotfiles` funciona?

3. **dotbot**:
   - Usa YAML declarativo — mostre o install.conf.yaml
     equivalente para o link/ atual
   - Suporta hooks para os init scripts?
   - Mais simples que chezmoi, menos features

4. **Stow** (GNU stow):
   - Apenas symlinks, sem templates — mais limitado
   - Zero config adicional — é só `stow -t $HOME link`

5. **Recomendação**: dado que o repo tem >15 anos de história
   customizada, qual ferramenta faz sentido adotar (ou não)?
   Critérios: curva de aprendizado, poder expressivo,
   manutenção ativa, compatibilidade com o que já existe.

Output: análise comparativa + recomendação justificada.
Não migre sem confirmação.
```

---

## Como usar estes prompts

1. Copie o bloco de código do prompt desejado
2. Cole numa nova sessão Claude Code com `~/.dotfiles` como CWD
3. Os prompts são independentes entre si — podem ser executados em qualquer ordem
4. Prompts que geram relatórios (sem modificar código) são seguros para rodar a qualquer momento
5. Prompts que propõem patches pedem confirmação antes de aplicar

**Ordem sugerida de execução:**

```
Diagnóstico primeiro (sem modificações):
  13 → 14 → 16 → 17 → 22 → 23

Qualidade e segurança (modificações cirúrgicas):
  15 → 18 → 19 → 20 → 24

Testes (adiciona cobertura):
  7 → 8 → 9 → 12

Performance (mudanças de carregamento):
  25 → 26 → 27

Modernização (maior impacto, maior risco):
  28 → 36 → 38 → 29
```
