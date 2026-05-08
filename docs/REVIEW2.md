# Revisão Global do Dotfiles — Rodada 2 (deep)

> Continuação de [`REVIEW.md`](REVIEW.md). Esta rodada cobriu sistematicamente `source/` (40 arquivos, ~4.4k linhas), `init/` (16 arquivos, ~1.7k linhas), `bin/dotfiles` (~837 linhas) e o repo-level. **Não duplica os IDs de REVIEW.md (B1-B2, R1-R4, H1-H3, S1-S4).** Cada achado abaixo foi verificado lendo o arquivo direto antes de entrar nesta lista — falso-positivos dos agents foram descartados.
>
> Snapshot em **2026-04-30**.

## Sumário

| Severidade | Quantidade |
| ---------- | ---------: |
| Alta       |         12 |
| Média      |         11 |
| Baixa      |          7 |
| **Total**  |     **30** |

Áreas: `source/` (10), `init/` (12), `bin/dotfiles` (5), repo-level (3).

---

## source/

### SRC-01 — `git()`/`ssh()`/`scp()`/`sftp()`/`slogin()` shadowam builtins e hardcodam `/usr/bin/`

**Arquivo:** `source/30_connection.sh:9-58`
**Tipo:** bug + risco
**Severidade:** alta

**Descrição:** As 5 funções definem-se com o mesmo nome dos comandos correspondentes e chamam `eval /usr/bin/<cmd> ${QUOTE_ARGS}`. Dois problemas distintos:

1. **Path hardcoded:** em macOS com Homebrew, `git` vive em `/opt/homebrew/bin/git` (M1) ou `/usr/local/bin/git` (Intel). `/usr/bin/git` é o XCode CLT — versão antiga e às vezes ausente. Em distros Linux que põem git em `/bin/git`, idem.
2. **Shadowing universal:** toda invocação interativa de `git`/`ssh`/`scp`/etc. passa por `eval` com construção dinâmica de string. Argumentos contendo `'` (comum em commit messages, comandos remotos) são quebrados ou injetados.

**Correção proposta:** Remover `eval` e o loop `QUOTE_ARGS`. Usar `command /usr/bin/env <cmd> "$@"` (preserva PATH) ou simplesmente `command <cmd> "$@"` sem hardcodar caminho.

---

### SRC-02 — Tilde literal em `PATH` (não expande dentro de aspas)

**Arquivo:** `source/50_node.sh:3`
**Tipo:** bug
**Severidade:** alta

**Descrição:** `export PATH="~/.nave/installed/default/bin:$PATH"`. Tilde dentro de aspas duplas **não expande** — PATH passa a conter literalmente `~/.nave/...`. Qualquer binário em `~/.nave/installed/default/bin` fica inacessível pelo nome.

**Correção proposta:** `export PATH="$HOME/.nave/installed/default/bin:$PATH"`.

---

### SRC-03 — Path quebrado: `$HOME~/.local/...`

**Arquivo:** `source/01_path.sh:54`
**Tipo:** bug
**Severidade:** alta

**Descrição:** Linha contém `$HOME~/.local/share/flatpak/exports/share` — quando expandido vira `/Users/sierra~/.local/...`, diretório que nunca existirá. O guard `[[ -d "$p" ]]` mais abaixo silencia o erro, mas a entrada nunca é adicionada ao PATH.

**Correção proposta:** Trocar `$HOME~/` por `$HOME/`.

---

### SRC-04 — `sed -i` com sintaxe BSD/GNU mista e arquivo duplicado

**Arquivo:** `source/50_file.sh:329`
**Tipo:** bug
**Severidade:** alta

**Descrição:** `sed -i ${number}d $HOME/.todo "$HOME/.todo"` tem dois problemas:
1. BSD `sed` (macOS) exige sufixo após `-i` (ex: `-i ''`); sem isso interpreta `${number}d` como sufixo e o `d` é perdido.
2. `$HOME/.todo` aparece **duas vezes** — passa o arquivo como argumento posicional duas vezes; em GNU sed processa um, em BSD processa ambos com semântica imprevisível.

**Correção proposta:** `sed -i.bak "${number}d" "$HOME/.todo"` (funciona em ambos; cria backup `.todo.bak` que pode ser removido em seguida).

---

### SRC-05 — `eval git commit -m "\"$@\""` em `cmt`/`cmta`

**Arquivo:** `source/50_vcs.sh:39, 42`
**Tipo:** risco
**Severidade:** alta

**Descrição:** `eval git commit -m "\"$@\""`. `git` aceita argumentos diretamente — o `eval` aqui é gratuito e abre injeção. Mensagem como `"foo'; rm -rf x"` é interpretada pelo shell.

**Correção proposta:** `git commit -m "$*"` (sem `eval`, com `$*` para juntar a mensagem em uma string).

---

### SRC-06 — `grep -P` (Perl regex) em código que roda em macOS

**Arquivo:** `source/50_system.sh:28`
**Tipo:** bug (portabilidade)
**Severidade:** média

**Descrição:** Função `ipif` usa `grep -P` para regex Perl. BSD `grep` (default no macOS) não tem `-P`. Função aborta com `grep: invalid option -- P` na primeira chamada num Mac.

**Correção proposta:** Trocar a regex por ERE (`grep -E`) — o backreference `(?2)` pode ser substituído por repetição literal. Ou usar `perl -ne '...'`.

---

### SRC-07 — `$(date ...)` rodando dentro de `PS1` a cada prompt

**Arquivo:** `source/50_prompt.sh:145`
**Tipo:** sugestão (performance)
**Severidade:** média

**Descrição:** `PS1="$PS1${bracket}[${yellow}$(date +"...")...]"`. Como o `$(date)` está **dentro** das aspas duplas que definem PS1, é avaliado uma vez no momento da atribuição — então é OK aqui. **Mas** linha 145 é construída dentro de `__prompt_command`, que roda a cada PROMPT_COMMAND. Logo `date` executa a cada Enter. Em conexões SSH lentas, perceptível.

**Correção proposta:** Trocar `$(date +"...")` por `\D{...}` ou `\t` no próprio PS1 — o bash expande timestamp embutido sem fork.

---

### SRC-08 — `mkdir -p $DOTFILES/caches/z` durante shell startup

**Arquivo:** `source/50_file.sh:72`
**Tipo:** higiene
**Severidade:** baixa

**Descrição:** `mkdir -p` sem aspas (quebra se DOTFILES tem espaço) **e** roda sincronamente em todo shell login. Pequeno custo, mas não-essencial nesse momento.

**Correção proposta:** `[[ -d "$DOTFILES/caches/z" ]] || mkdir -p "$DOTFILES/caches/z"`.

---

### SRC-09 — `eval` dentro de `printf %.0s-` em `tasks`

**Arquivo:** `source/50_file.sh:328`
**Tipo:** higiene
**Severidade:** baixa

**Descrição:** `eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo` usa `eval` para forçar brace expansion com variável. Padrão arriscado se COLUMNS for atacante-controlado (não é, vem do shell, mas o smell é o mesmo).

**Correção proposta:** `printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'` — sem eval.

---

### SRC-10 — `if [[ ... ]] then ` sem `;` antes do `then`

**Arquivo:** `source/30_connection.sh:3`
**Tipo:** bug
**Severidade:** média

**Descrição:** `if [[ \`ssh-add -l\` != *id_?sa* ]] then` — em bash interativo isso pode passar (o `then` na próxima palavra se ele não usar newline), mas em scripts sourceados sob `set -e` ou em variantes mais estritas (bash --posix), faz parse error. Já há comentário `# @todo comentei pq tava dando erro de parser no zsh` na função, indicando que o autor já bateu nisso.

**Correção proposta:** `if [[ ... ]]; then`.

---

## init/

### INIT-01 — `pacman -qq update` / `-qq dist-upgrade` não existem em Arch

**Arquivo:** `init/20_linux_apt.sh:45-46, 584, 588`
**Tipo:** bug
**Severidade:** alta

**Descrição:** Branch `is_archlinux` faz `sudo pacman -qq update` e `sudo pacman -qq dist-upgrade`. `pacman` não tem flag `-qq` (é apt-ismo) e não tem subcomando `update`/`dist-upgrade` (é `-Syy`/`-Syu`). Em Arch, comando aborta com erro. Branches Arch ficam permanentemente quebradas.

**Correção proposta:** `sudo pacman -Syyu --noconfirm` (sync + refresh + upgrade) e `sudo pacman -S --noconfirm "$package"` para install.

---

### INIT-02 — `continue` fora de loop em `install_docker_linux`

**Arquivo:** `init/50_docker.sh:17`
**Tipo:** bug (syntax/runtime error)
**Severidade:** alta

**Descrição:** Dentro do `else` do `if (is_ubuntu)` … `elif (is_debianOS)` … o autor escreveu `continue;`. Mas `install_docker_linux` é uma função, não um loop — bash emite warning `continue: only meaningful in a for, while, or until loop` e prossegue. Branch destinado a abortar não aborta.

**Correção proposta:** Trocar `continue;` por `return 1` ou `return`.

---

### INIT-03 — `sudo sudo groupadd docker`

**Arquivo:** `init/50_docker.sh:20`
**Tipo:** bug
**Severidade:** alta

**Descrição:** Linha literal: `sudo sudo groupadd docker $SAIDA`. O segundo `sudo` é interpretado como o programa a rodar — em sistemas que tenham `sudo` no PATH, isso vira `sudo sudo …` (eleva privilégio e roda `sudo groupadd …`). Funciona por acaso, mas é claramente um typo.

**Correção proposta:** Remover um `sudo`: `sudo groupadd docker 2>/dev/null || true` (suprime erro se grupo já existe).

---

### INIT-04 — `$SAIDA` referenciada mas nunca definida

**Arquivo:** `init/50_docker.sh:5, 12, 13, 14, 15, 20, 21, 64, 70`
**Tipo:** bug
**Severidade:** alta

**Descrição:** Variável `$SAIDA` aparece no fim de ~9 comandos (sufixo aparente de redirecionamento), mas nunca é definida no script nem em arquivos sourceados anteriores. Em `set -u` quebraria; sem ele, expande para nada — comandos rodam, mas a intenção (provavelmente `>/dev/null 2>&1`) é perdida.

**Correção proposta:** Definir no topo (`SAIDA=">/dev/null 2>&1"`) **e** chamar via `eval` (atual sintaxe não vai redirecionar mesmo se SAIDA contiver `>`); ou substituir `$SAIDA` por `>/dev/null 2>&1` literal nos pontos de uso.

---

### INIT-05 — `20_ubuntu_apt.sh` sem shebang

**Arquivo:** `init/20_ubuntu_apt.sh:1`
**Tipo:** bug (portabilidade)
**Severidade:** alta

**Descrição:** Primeira linha é comentário `# Ubuntu-only stuff. Abort if not Ubuntu.`. Nenhum shebang. O orquestrador `bin/dotfiles` faz `source "$2"` então isso herda o intérprete pai (bash), funciona — **mas** se alguém invocar o script diretamente (`./20_ubuntu_apt.sh`), o kernel chama `/bin/sh`, e bashisms (`source`, `[[ ]]`, `+=` em arrays) falham.

**Correção proposta:** Adicionar `#!/usr/bin/env bash` na linha 1.

---

### INIT-06 — `40_osx_fonts.sh` é placeholder vazio

**Arquivo:** `init/40_osx_fonts.sh`
**Tipo:** higiene
**Severidade:** baixa

**Descrição:** Arquivo tem 1 linha vazia. Sem shebang, sem código. `do_stuff` ainda assim sourcerá durante install, sem efeito mas com overhead trivial.

**Correção proposta:** Remover o arquivo, ou popular com a instalação de fontes OSX (provável intenção original — ver init/30_osx_homebrew_casks.sh para fontes via cask).

---

### INIT-07 — `set -x` ligado sem `set +x` correspondente

**Arquivo:** `init/60_golang.sh:27` (sem desativação)
**Tipo:** higiene
**Severidade:** média

**Descrição:** Bloco `(set -x; set +e; go get ...)` está dentro de subshell, então `set -x` morre com a subshell — **mas** o output verbose do `set -x` continua até o fim do subshell, gerando ruído pesado durante install. Sem `set +x` antes do `)` final, o trace permanece para todos os ~15 `go get` listados.

**Correção proposta:** Adicionar `set +x` antes do `)` ou remover `set -x` completamente.

---

### INIT-08 — Múltiplos `curl ... | bash` sem checksum

**Arquivo:** `init/10_osx_xcode.sh:13-14` (asdf), `init/40_linux_beef.sh:24` (RVM), `init/50_node.sh:10` (volta)
**Tipo:** risco (segurança)
**Severidade:** média

**Descrição:** Padrão `curl … | bash` em 3 instaladores. Cada um confia em (1) HTTPS válido na hora, (2) integridade do upstream, (3) sem MITM. Falha em qualquer ponto = RCE como o usuário. Os 3 são domínios trusted (github.com, get.volta.sh, raw.githubusercontent.com), mas ausência de pin de SHA significa que comprometimento upstream é catastrófico.

**Correção proposta:** Para cada instalador, baixar para arquivo, verificar SHA256 fixo, **depois** executar. Manter referência da última SHA verificada num comentário.

---

### INIT-09 — Sem `set -e` em scripts de init que fazem `sudo apt-get`/`pacman`/`yum`

**Arquivo:** `init/20_linux_apt.sh:42-49`, `init/20_ubuntu_apt.sh` (todo), `init/50_docker.sh` (todo)
**Tipo:** bug
**Severidade:** média

**Descrição:** Sem `set -e` e sem `|| exit 1` por linha, falha de `apt-get update` (rede caída, repo 404, GPG inválido) não interrompe. Script segue tentando instalar pacotes contra um índice obsoleto. Estado final do sistema fica indeterminado.

**Correção proposta:** Adicionar `set -e` no topo de cada script de init. Onde precisar suprimir (ex: `xattr -d` que falha se atributo não existe), usar `|| true` explícito.

---

### INIT-10 — `cd $DOTFILES/vendor/git-extras && sudo make install` sem `|| exit`

**Arquivo:** `init/20_linux_apt.sh:599-601`
**Tipo:** bug
**Severidade:** média

**Descrição:** Se `cd` falha (DOTFILES vazio, vendor não foi clonado), o `&&` salta o `make install` mas o script segue. O autor provavelmente esperava `set -e`-like behavior — não tem.

**Correção proposta:** `cd "$DOTFILES/vendor/git-extras" || exit 1` numa linha; `sudo make install` em outra.

---

### INIT-11 — `dpkg -i "$installer_file"` sem checagem

**Arquivo:** `init/20_ubuntu_apt.sh:362`
**Tipo:** bug
**Severidade:** média

**Descrição:** `dpkg -i` falha em dependências quebradas — exit code não-zero é silenciado. Próximas linhas dependentes do pacote rodam contra estado parcial.

**Correção proposta:** `sudo dpkg -i "$installer_file" || sudo apt-get install -f --yes` (auto-conserto de deps).

---

### INIT-12 — `local binroot=…` no escopo global

**Arquivo:** `init/30_osx_homebrew_recipes.sh:80`
**Tipo:** higiene
**Severidade:** baixa

**Descrição:** `local` fora de função em bash não é hard error mas vaza warning e a variável vira global mesmo assim, poluindo o orquestrador parent (`bin/dotfiles` que sourceia este arquivo).

**Correção proposta:** Remover `local` ou envolver o trecho em função.

---

## bin/dotfiles

### ORCH-01 — `export CORE=/sierra/Core` hardcoded e nunca usado

**Arquivo:** `bin/dotfiles:12`
**Tipo:** bug + higiene
**Severidade:** alta

**Descrição:** `CORE` aponta para `/sierra/Core` (diretório que provavelmente só existe na máquina pessoal do autor). É exportado, então qualquer script downstream que checar `$CORE` vê o path quebrado. Não há nenhum consumidor confirmado no repo (`grep -r '\$CORE'` retorna 0 hits significativos), o que torna pior — é exportação morta com nome bonito.

**Correção proposta:** Remover linha 12. Se o autor precisar disso, mover para `link/.zshrc` ou `source/1000_sierra_only.sh`.

---

### ORCH-02 — `[[ ARGV.include == "-h" || ARGV.include == "--help" || ... ]]`

**Arquivo:** `bin/dotfiles:819`
**Tipo:** bug (dead code)
**Severidade:** média

**Descrição:** `ARGV.include` é uma string literal — não há variável `ARGV` em bash, e `.include` não é sintaxe válida. Esses comparadores nunca casam. O `if` ainda funciona porque os outros operandos do `||` (`"$1" == "-h"`, `"$1" == "--help"`, etc.) cobrem o caso. Provavelmente é refugo de tradução de Ruby/Perl.

**Correção proposta:** Remover os dois primeiros operandos do `||`. Forma final: `if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" || "$1" == "h" || -z "$1" ]]; then`.

---

### ORCH-03 — `pinpoint gcc` chamado mas função não existe no escopo do orquestrador

**Arquivo:** `bin/dotfiles:778`
**Tipo:** bug
**Severidade:** alta

**Descrição:** `pinpoint` é função definida em `source/00_dotfiles.sh` (sourceada apenas em **shells interativos**, não pelo orquestrador). Quando `bin/dotfiles install` roda, `pinpoint` não existe. O `if ! pinpoint gcc; then` faz `command not found` e exit code 127 — o `!` inverte para 0, então o `if` é **falso**, o ramo de erro nunca dispara, e a checagem efetiva de gcc não acontece.

**Correção proposta:** Substituir por `if ! command -v gcc >/dev/null 2>&1; then`.

---

### ORCH-04 — Variáveis sem aspas em `copy_test`/`copy_do`/`link_do`

**Arquivo:** `bin/dotfiles:438` (`[ -d $1 ]`), `bin/dotfiles:447, 448, 452` (`[ -d $2 ]`, `[ -d ~/$1 ]`)
**Tipo:** bug (quoting)
**Severidade:** média

**Descrição:** Todos os testes de existência usam `[ -d $1 ]` sem aspas. Se algum arquivo em `copy/` ou `link/` tiver espaço no nome (improvável hoje, mas o `.gitconfig.local.example` poderia ser renomeado), word splitting quebra o teste. Pior: `[ -d ]` (sem args) sempre retorna 0, mascarando bugs.

**Correção proposta:** Padronizar `[[ -d "$1" ]]` em todos os testes do bloco copy/link.

---

### ORCH-05 — `source "$2"` em `init_do` sem propagação de erro

**Arquivo:** `bin/dotfiles:430-433`
**Tipo:** bug
**Severidade:** média

**Descrição:** `init_do` faz só `source "$2"`. Se um script de init usa `return 1`, o source retorna 1 mas `init_do` não captura nem propaga. O loop em `do_stuff` segue para o próximo init, deixando o sistema em estado parcial sem alertar o usuário.

**Correção proposta:** `source "$2" || { e_error "Init falhou: $2"; return 1; }` e checar o retorno na chamada de `init_do`.

---

## Repo-level

### REPO-01 — `CHANGELOG.md` em formato Keep-a-Changelog (viola regra global do usuário)

**Arquivo:** `CHANGELOG.md` (todo)
**Tipo:** higiene
**Severidade:** média

**Descrição:** O usuário tem regra global em `~/.claude/CLAUDE.md`: todos os projetos devem usar formato "Release Notes" com seções `### ✨ Novidades / 🎨 Melhorias / 🐛 Correções / 🔧 Técnico` e itens em `- [x]`/`- [ ]`. O `CHANGELOG.md` atual usa Keep-a-Changelog (`### Added/Changed/Fixed`). Versionamento também heterogêneo (`[0.4.0]`, `[Unreleased]` sem prefixo `v`).

**Correção proposta:** Reescrever no formato Release Notes mantendo o histórico (preservar conteúdo, trocar só headers e bullets). Referência canônica está em `~/Dev/Banlek/banlek-uploader/CHANGELOG.md`.

---

### REPO-02 — Logs do tmux órfãos no top-level (untracked)

**Arquivo:** `tmux-client-27975.log`, `tmux-client-28140.log` (raiz do repo)
**Tipo:** higiene
**Severidade:** baixa

**Descrição:** Dois arquivos de log do tmux estão na raiz do repo. Verificado via `git ls-files`: não estão tracked. `git status` também não os reporta como `??`, sugerindo que estão cobertos por algum padrão do `gitignore_global` ou do `.gitignore` local. Risco baixo, mas o working tree tem lixo de runtime acumulando.

**Correção proposta:** `rm tmux-client-*.log` no working tree e adicionar `tmux-*.log` explicitamente ao `.gitignore` deste repo para garantir que não vazem se alguém usar `git add -A`.

---

### REPO-03 — `test/` tem 4 arquivos mas nenhum runner

**Arquivo:** `test/test_array.sh`, `test_path_remove.sh`, `test_setdiff.sh`, `teste.sh`
**Tipo:** sugestão
**Severidade:** baixa

**Descrição:** Existem testes para utilitários internos do `bin/dotfiles` (array, path_remove, setdiff), mas nenhum mecanismo dispara — não há runner, hook, ou doc explicando como rodar. README sequer menciona. Soma-se a H3 (sem CI/hooks): testes existem mas estão mortos.

**Correção proposta:** Wrapper `bin/dotfiles-test` que roda `for f in test/test_*.sh; do bash "$f" || fail=1; done`. Documentar no README. Considerar incluir no pre-push hook proposto em `PROMPTS.md` § 2.

---

## O que foi verificado e está limpo

- **Detecção de OS** em `bin/dotfiles` (uname/lsb_release/$OSTYPE) — coerente, com fallback.
- **Backup step** — cria `~/.dotfiles/backups/<timestamp>/` antes de sobrescrever; lógica está OK (apesar de ORCH-04 tocar adjacente).
- **Loop sudo keep-alive** (`bin/dotfiles:589`) — é o padrão `cowboy` correto: `kill -0 "$$" || exit` mata a subshell quando o pai morre. Não trava CPU (`sleep 10`).
- **Helpers de logging** (`e_header`, `e_success`, etc.) — consistentes e usados.
- **Arrays no `30_osx_homebrew_recipes.sh`** — quoting em `for pkg in "${recipes[@]}"` está correto.

## Próximos passos sugeridos

1. **Triagem rápida**: confirmar se INIT-01..INIT-05 já são conhecidos. Se `dotfiles install` não roda há tempo numa máquina nova Linux, esses bugs nem foram exercitados — alta chance de serem regressões silenciosas.
2. Criar prompts em `PROMPTS.md` para os achados mais ortogonais (SRC-01 git/ssh shadowing; INIT-02..INIT-05 docker; ORCH-01 CORE).
3. Migrar achados menores (SRC-08, SRC-09, INIT-06, REPO-02) para issues GitHub se houver — granularidade pequena demais para PR único.

## Correções aplicadas (2026-05-07)

Sessão de revisão geral + compatibilidade Linux. Issues abaixo foram corrigidos:

| ID | Arquivo | Fix |
|----|---------|-----|
| **SRC-01** | `source/30_connection.sh:17–40` | `/usr/bin/{git,ssh,scp,sftp,slogin}` → `command <cmd>` |
| **SRC-02** | `source/50_node.sh:3` | `~/.nave/...` → `$HOME/.nave/...` no export PATH |
| **SRC-04** | `source/50_file.sh:386` | `sed -i` portável: branch Darwin/Linux; removido argumento duplicado |
| **SRC-06** | `source/50_system.sh:36` | `grep -P` (PCRE, quebra no macOS) → `[[ "$1" =~ regex ]]` |
| **ORCH-01** | `bin/dotfiles:12` | `export CORE=/sierra/Core` → condicional `[[ -d ... ]] && export` |

Adicionalmente, foram feitas melhorias de **compatibilidade com Linux** não cobertas nos audits anteriores:

| Componente | Arquivo | Melhoria |
|------------|---------|----------|
| OS detection | `bin/dotfiles:111–155` | Todas as funções `is_*` ganham fallback via `/etc/os-release` além de `/etc/issue` |
| Ubuntu derivatives | `bin/dotfiles:142–151` | `is_ubuntu()` agora reconhece `ID=linuxmint`, `zorin`, `pop`, `elementary` e `ID_LIKE=ubuntu` |
| Desktop detection | `bin/dotfiles:152–158` | `is_ubuntu_desktop()` verifica metapacotes de Mint, Zorin, Pop!_OS, elementary além de `ubuntu-desktop` |
| Docker codename | `init/50_docker.sh:26–29` | Usa `UBUNTU_CODENAME` do `/etc/os-release` como fallback do `lsb_release -cs` para distros derivadas |

Issues confirmados como já corrigidos antes desta sessão: **B2**, **SRC-03**, **SRC-05**, **INIT-02**, **INIT-03**.

---

## Apêndice — falsos-positivos descartados durante verificação

- "main executada duas vezes" em `bin/dotfiles:825,837`: cada branch tem `exit;`, o `main` final só roda se nenhum branch matched. Não é bug.
- "loop de keep-alive sudo trava CPU": padrão correto, ver acima.
- Múltiplos achados duplicando B2/R2 já em `REVIEW.md` (path hardcoded em homebrew, eval do thefuck): omitidos.
