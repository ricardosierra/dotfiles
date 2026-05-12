# Auditoria 2026-Q2 — Rodada 3

Snapshot em **2026-05-11**. Continuação de [`REVIEW.md`](REVIEW.md) (rodada 1) e
[`REVIEW2.md`](REVIEW2.md) (rodada 2). Esta rodada cobre o que sobrou após os
fixes recentes: ferramentas fósseis ainda referenciadas, scripts perigosos no
PATH, vendors substituíveis, código pessoal acoplado, sobreposição de prompts.

**Nada foi removido até esta rodada.** Este documento é o inventário e plano
de cleanup — ações esperam aprovação explícita por fase (ver §5).

---

## 1. Diagnóstico executivo

Pós-`REVIEW2.md`, o repo está saudável em sintaxe (shellcheck 0 erros, 58 bats
+ 42 legacy ok). O que sobra é **escopo**: 15 anos de tooling morto, scripts
ofensivos no PATH default, código pessoal acoplado, e 4 sistemas de prompt
coexistindo.

### Riscos atuais

| Risco | Onde | Severidade |
|---|---|---|
| Ferramenta ofensiva no bootstrap | `init/40_linux_beef.sh`, `bin/pentest/*` | Alta |
| Firewall destrutivo | `bin/setup-tor-iptables` | Alta |
| Symlinks quebrados versionados | `./default`, `./bin/subl` | Média |
| Acoplamento de máquina | `$CORE=/sierra/Core`, `ANDROID_HOME` hardcoded | Média |
| Tooling fóssil ativo | nave, vendor/rbenv (+ 6 plugins), powerline-python, Pebble SDK | Média |
| Shadowing de comandos | `source/30_connection.sh:22-37` (`git()`, `ssh()`, `scp()`) | Alta |
| 1622 linhas comentadas | `source/50_docker_programs.sh` | Baixa |
| `.DS_Store` + `*.local` versionados | `./`, `copy/` | Média |

### O que vale preservar
- Núcleo de detecção de OS em `bin/dotfiles` (testado em bats)
- Helpers `pinpoint`, `path_remove`, `array_*`, `setdiff` em `source/00_helps.sh`
- Infraestrutura de testes (`test/run_tests.sh`, shellcheck pre-push hook)
- Aliases git (`source/50_vcs.sh`) e workflow (`source/100_workflow.sh`)
- Documentação trilingual em `docs/{en,pt,es}/`
- Scripts Claude com XDG path e auto-reset

---

## 2. Inventário classificado

Legenda de categorias:
- **KEEP** — ainda útil, sem mudança
- **KEEP_WITH_CHANGES** — útil, mas precisa refator
- **ARCHIVE** — legado opt-in (move pra `archive/`)
- **REMOVE** — pode sair com segurança
- **REPLACE** — substituir por alternativa moderna
- **UNKNOWN** — inspecionar antes de decidir

Legenda de prioridade: **P0** imediato · **P1** importante · **P2** desejável · **P3** cosmético

### 2.1 Raiz

| Caminho | Cat | Ação | Justificativa | Prio |
|---|---|---|---|---|
| `./default` (symlink) | REMOVE | `git rm` | symlink pra `/home/sierra/.nave/installed/default` quebrado em macOS | P0 |
| `./.DS_Store` | REMOVE | `git rm --cached` + gitignore | lixo macOS versionado | P0 |
| `./Dockerfile`, `./docker-compose.yml` | UNKNOWN | revisar uso | sem doc, criados há 1+ ano | P2 |
| `./backups/`, `./caches/` | KEEP | já gitignored | runtime do orchestrator | — |
| `./ansible/roles/` | ARCHIVE | `archive/ansible/` | só tem `roles/` vazio | P2 |
| `./dependency/shopt` | UNKNOWN | inspecionar — 1 arquivo isolado | sem contexto | P2 |

### 2.2 `bin/` — destaques (lista completa em §2.2 do PR)

**Revisado após inspeção de conteúdo (não apenas nome):** muitos dos scripts em
`bin/pentest/`, `bin/games/`, `bin/life/`, `bin/security/` são utilitários
legítimos, não fósseis. Reclassificados abaixo.

| Caminho | Cat | Justificativa | Prio |
|---|---|---|---|
| `bin/subl` → ST2 | REMOVE ✅ | Sublime Text 2 não existe mais — **removido na Fase 1** | P0 |
| `bin/curlsubl` | KEEP_WITH_CHANGES | retargetar pra EDITOR atual (não só subl); usa `$DOTFILES/caches/` que existe | P2 |
| `bin/isoInCdrw` | ARCHIVE | `cdrecord dev=0,1,0` hardcoded; CDRW raramente usado em 2026 | P2 |
| `bin/setup-tor-iptables` | KEEP_WITH_CHANGES | requer container `tor` (existe em `50_docker_programs.sh`); modifica firewall — adicionar dry-run + reverse no script | P1 |
| `bin/update-rust-nightly` | REMOVE | `rustup toolchain install nightly` é canônico; script atual hackeia brew cellar | P1 |
| `bin/multi_firefox` | ARCHIVE | Firefox tem profiles nativos (`-P`); patch de binário quebra com auto-update | P2 |
| `bin/pentest/pentest` | KEEP_WITH_CHANGES | PenScan: DNS pulls, nmap ping sweep, hostname resolver — útil pra recon defensiva; precisa de `toilet`/`nmap` instalados | P2 |
| `bin/pentest/scan` | KEEP | port scanner via nmap (Ruby) — útil | — |
| `bin/pentest/zscan` | KEEP_WITH_CHANGES | Zenity GUI pra ping/netstat/whois — só Linux desktop; precisa de zenity | P3 |
| `bin/pentest/checkip` | KEEP | curl ipinfo.io — utilitário simples | — |
| `bin/pentest/email_list` | UNKNOWN | crawler de emails via lynx/wget — OSINT/recon ou spam (depende do uso); revisar | P3 |
| `bin/pentest/ddos` | REMOVE | nome alarmante, conteúdo é placebo (apenas `lynx $1 &` 2x + `killall lynx`); não faz DDoS real | P1 |
| `bin/security/crypt_l4sencfs` | KEEP_WITH_CHANGES | encfs ainda instalável (legacy mas funcional); pt-BR menu | P3 |
| `bin/calculadora` | KEEP | utilitário pessoal, sem doc — manter como está | — |
| `bin/games/*` (campo_minado, jogo_da_velha) | KEEP | shell games funcionais, autocontidos | — |
| `bin/life/tempo` | KEEP_WITH_CHANGES | scraping de `folha.uol.com.br/folha/tempo/br-piracicaba` (URL provavelmente morta); substituir por `curl wttr.in/Piracicaba` | P2 |
| `bin/network/transfer` | KEEP_WITH_CHANGES | usa transfer.sh (ativo); adicionar shebang | P3 |
| `bin/network/email`, `email-auth` | KEEP_WITH_CHANGES | SMTP via /dev/tcp, depende de `links` | P3 |
| `bin/network/roteador` | UNKNOWN/ARCHIVE | compartilhamento NAT root-only, antigo (2008?) — revisar | P2 |
| `bin/text/sincleg` | KEEP | sincronizador de legenda `.srt` via `bc`, autocontido | — |
| `bin/system/{memory,clear-snap,system_cleaner}` | KEEP_WITH_CHANGES | utilidades Linux; adicionar guard `is_linux` | P3 |
| `bin/files/*` | KEEP_WITH_CHANGES | conversores/minify; verificar deps (imagemagick, ffmpeg, libreoffice) | P3 |
| `bin/osx_*` | KEEP_WITH_CHANGES | renomear pra `macos_*` | P3 |
| `bin/dev/docker-compose` | UNKNOWN | risco de shadowar binário do sistema | P1 |
| `bin/$`, `bin/dotfiles`, `bin/dotfiles-install-hooks`, `bin/eachdir`, `bin/gpr`, `bin/manh`, `bin/manp`, `bin/poll-url`, `bin/rename`, `bin/updateforks` | KEEP | utilitários ativos | — |

### 2.3 `source/` — destaques

| Caminho | Cat | Justificativa | Prio |
|---|---|---|---|
| `source/01_path.sh` | KEEP_WITH_CHANGES | shebang `#!/usr/bin/zsh` errado (file é source-only); remover `$CORE/bin` (variável undefined em macOS). **MANTER** `bin/pentest`, `bin/games`, `bin/life`, `bin/security` no PATH — contêm utilitários legítimos (ver §2.2 revisada) | P1 |
| `source/01_exports.sh` | KEEP_WITH_CHANGES | `ANDROID_HOME="/home/$USER/$DOTFILES_FOLDER_PROGRAMS/..."` quebra em macOS | P1 |
| `source/30_connection.sh` | KEEP_WITH_CHANGES | `git()`/`ssh()`/`scp()` shadowing com `eval /usr/bin/<cmd>` — SRC-01 ainda presente | P0 |
| `source/50_node.sh` | KEEP_WITH_CHANGES | remover `nave_*` e `npm_globals` fóssil (phonegap 3.6, cordova 5.0, bower, grunt-cli) | P1 |
| `source/50_ruby.sh` | KEEP_WITH_CHANGES | remover bloco `vendor/rbenv/bin` | P1 |
| `source/10_powerline.sh` | REMOVE/REPLACE | depende de python2 powerline-status morto | P1 |
| `source/50_osx.sh` | ARCHIVE_PARTIAL | extrair `vm_template`, `buspirate_*` pra `archive/personal/` | P2 |
| `source/50_docker_programs.sh` (1622 linhas) | KEEP_WITH_CHANGES | 52 funções de fallback nativo→docker (`if pinpoint X then native else docker`); 28 já têm o guard. **NÃO archive.** Revisar funções sem fallback + remover refs a programas mortos (atom) | P1 |
| `source/50_pebble.sh` | KEEP_WITH_CHANGES | só 4 linhas; guard `[[ -e $path ]]` já protege se SDK não existir. Inofensivo. Pode permanecer ou ser removido — decisão do dono | P3 |
| `source/60_windows.sh` | KEEP_WITH_CHANGES | guard `is_windows` sempre false, mas as funções `youtube-dump` e `download-website` carregam mesmo assim. Mover essas pra `50_misc.sh` ou `50_file.sh` e deletar este arquivo | P2 |
| `source/80_work_station.sh` | REMOVE ✅ | arquivo de 0 bytes — **removido na Fase 1** | P0 |
| `source/1000_sierra_only.sh` | KEEP | decisão do dono: manter por enquanto | — |
| `source/90_dump.sh` | UNKNOWN | revisar conteúdo | P2 |
| `source/20_system.sh` + `50_system.sh` | UNKNOWN | sobreposição? | P3 |
| `source/50_dev.sh` + `50_developer.sh` | UNKNOWN | sobreposição? | P3 |
| `source/50_prompt.sh` + `10_powerline*` | KEEP_WITH_CHANGES | consolidar em 1 prompt (recomendado: starship) | P2 |

### 2.4 `init/` — destaques

| Caminho | Cat | Justificativa | Prio |
|---|---|---|---|
| `init/40_osx_fonts.sh` | REMOVE ✅ | 0 bytes — **removido na Fase 1** | P0 |
| `init/40_linux_beef.sh` | ARCHIVE/P0 | **verificado broken:** `libreadline6` removido no Ubuntu 22.04+, Ruby 1.9.3 não compila em OpenSSL moderno, BeEF abandonou esse instalador. Não funcional em 2026 | P0 |
| `init/20_linux_apt.sh` + `20_ubuntu_apt.sh` | KEEP_WITH_CHANGES | mergear num `20_apt.sh` com guards | P1 |
| `init/30_python_pip.sh`, `60_python.sh` | KEEP_WITH_CHANGES | `pip2/sudo pip` → `pipx` ou `uv tool install` | P1 |
| `init/50_node.sh` | REPLACE | remover `nave_install`, usar volta-only ou mise | P1 |
| `init/60_ruby.sh` | KEEP_WITH_CHANGES | `sudo apt install rbenv` quebra em macOS | P2 |
| `init/30_osx_homebrew_{casks,recipes}.sh` | KEEP_WITH_CHANGES | migrar pra `brew bundle` + Brewfile | P2 |
| `init/10_osx_xcode.sh`, `init/50_docker.sh`, `init/60_golang.sh`, `init/60_php.sh`, `init/50_vim.sh` | KEEP_WITH_CHANGES | renomear `osx_*` → `macos_*` quando aplicável | P3 |

### 2.5 `vendor/`

| Caminho | Cat | Justificativa | Prio |
|---|---|---|---|
| `vendor/rbenv` (+ 6 plugins em `link/.rbenv/plugins/`) | REPLACE | migrar pra asdf/mise; já existe asdf nos init scripts | P1 |
| `vendor/git-extras` (1.9MB) | REPLACE | `brew install git-extras` / `apt install git-extras` | P2 |
| `vendor/rename` | REPLACE | brew/apt | P2 |
| `vendor/z` | REPLACE | `zoxide` (brew/apt) | P2 |
| `vendor/.tmux` (gpakosz) | KEEP | sólido, sem alternativa equivalente | — |

### 2.6 `copy/`, `config/`, `conf/`

| Caminho | Cat | Justificativa | Prio |
|---|---|---|---|
| `.DS_Store`, `copy/.DS_Store` | OK ✅ | nunca foi tracked; .gitignore atualizado na Fase 0 | — |
| `copy/.dotfilesconfig.local`, `copy/.gitconfig.local` | KEEP | dono optou por manter; ⚠️ `.gitconfig.local` contém nome/email reais — clones por terceiros copiam pra ~/ deles | P2 |
| `copy/.local/share/applications/*.desktop` | KEEP_WITH_CHANGES | revisar — Atom, Clementine, Cheese mortos | P3 |
| `copy/ShareMouse/com.bartelsmedia.ShareMouse.plist` | ARCHIVE | software comercial específico | P3 |
| `config/powerline/` | REMOVE | se remover powerline-python | P2 |
| `conf/manh/`, `conf/tic/` | UNKNOWN | inspecionar | P3 |
| `conf/linux/sudoers-dotfiles` | KEEP_WITH_CHANGES | auditar conteúdo; é instalado via `init/20_linux_apt.sh` | P1 |
| `conf/osx/*` | KEEP_WITH_CHANGES | renomear `conf/macos/` | P3 |

### 2.7 `docs/`

| Caminho | Cat | Justificativa | Prio |
|---|---|---|---|
| `docs/helper/source_30_docker.sh`, `source_50_vcs.sh` | ARCHIVE | **não são duplicatas:** são snippets de help (heredocs `cat <<-HELP` listando aliases). Mover pra `archive/docs-helper/` em vez de remover | P2 |
| `docs/2.0/` | ARCHIVE | stubs abandonados | P2 |
| `docs/{en,pt,es}/`, `REVIEW.md`, `REVIEW2.md`, `PROMPTS.md`, `PROMPTS2.md`, `STRUCTURE_PROMPT.md`, `audit.md` (este), `deprecations.md` | KEEP | — | — |

---

## 3. Coisas perigosas — top 9 (revisado)

1. `init/40_linux_beef.sh` — `curl|bash` raw.github.com, RVM global, BeEF (verificado broken em Ubuntu moderno)
2. `bin/setup-tor-iptables` — iptables sem snapshot/reverse; precisa de `--dry-run` + reverse
3. `bin/pentest/ddos` — nome alarmante (conteúdo é placebo); remover
4. `source/30_connection.sh:22-37` — `git()`/`ssh()`/`scp()` shadowing com eval
5. `bin/dotfiles` — 9 `eval` em referência indireta (R1 do REVIEW)
6. `source/01_path.sh` — shebang errado (`#!/usr/bin/zsh` em arquivo source-only) + `$CORE` undefined em macOS
7. `init/60_python.sh` — `sudo pip install` polui sistema (trocar por pipx)
8. `conf/linux/sudoers-dotfiles` — sudoers customizado (auditar conteúdo)
9. `copy/.gitconfig.local` versionado com nome/email reais — clones por terceiros propagam essa identidade

---

## 4. Como auditar

Scripts em `scripts/audit/`. Rodar tudo:

```sh
bash scripts/audit/run_all.sh
```

Saídas em `.audit/` (gitignored). Scripts individuais:

| Script | O que faz |
|---|---|
| `audit_symlinks.sh` | Symlinks quebrados |
| `audit_no_shebang.sh` | Scripts sem shebang |
| `audit_personal_paths.sh` | Hardcode de paths/ferramentas fósseis |
| `audit_shadowing.sh` | Funções que shadowam builtins |
| `audit_eval.sh` | Uso de `eval` (sem padrões legítimos) |
| `audit_dead_files.sh` | Arquivos com poucas referências |
| `audit_path_health.sh` | `$PATH` duplicado/missing dirs |
| `audit_executables.sh` | Tudo com bit de execução |
| `audit_large_files.sh` | Arquivos > 500KB |
| `audit_shellcheck.sh` | shellcheck severity=warning (vs error no hook) |
| `audit_shfmt.sh` | Diffs de formatação |

---

## 5. Plano de fases (próximas aprovações)

Status atual: **Fases 0, 1 (parcial), 2, 3 e Prompt #44 concluídas**.

| Fase | Conteúdo | Status |
|---|---|---|
| **0. Baseline** | scripts/audit/, docs/audit.md, docs/deprecations.md, .gitignore | ✅ feito |
| **1. Limpeza segura** | broken symlinks (`./default`, `bin/subl`), arquivos vazios (`init/40_osx_fonts.sh`, `source/80_work_station.sh`), `.DS_Store` no gitignore | ✅ feito (parcial — `*.local` mantidos por escolha) |
| **2. Archive de legados** | criar `archive/{legacy,legacy-security,docs-2.0,docs-helper}/` + README. Movidos: `init/40_linux_beef.sh`, `bin/{isoInCdrw,multi_firefox,update-rust-nightly}`, `docs/2.0/`, `docs/helper/`. Removido: `bin/pentest/ddos` (placebo) | ✅ feito |
| **3. Revisão script-por-script** | 27 scripts em `bin/{pentest,network,system,files,security,life,text}/` revisados. Veredictos: 5 KEEP, 17 KEEP_WITH_CHANGES, 5 ARCHIVE. 7 novos scripts propostos. Resultado em [`scripts-review.md`](scripts-review.md) | ✅ feito |
| **3.5. Prompt #44 — apply** | **Round 1** trivial: shebang em `network/transfer`, encoding fix em `files/search-in-pdf`, rename `convert-ogg-to-pdf` → `convert-ogg-to-mp3`. **Round 2** moderniz.: `life/tempo` → wttr.in, `system/memory` cross-platform Linux+macOS, `pentest/checkip` sem `yum` hardcoded, `system/clear-snap` + `system/system_cleaner` com guards `apt-get`/`dialog`. **Round 3** archive: `pentest/email_list`, `network/roteador`, `files/{convert-swfslide-to-pdf,convert-txt-to-ttsbook,get-wallpapers-hubble}` → `archive/legacy/` e `legacy-security/`. **Round 4** criados: `system/{port-killer,du-by-extension}`, `network/wifi-strength`, `files/dedupe`, `pentest/ssl-check`, `dev/git-cleanup`, `text/wc-by-language` | ✅ feito |
| **4. Fixes pendentes do REVIEW2** | `01_path.sh`: shebang `/usr/bin/zsh` removido + `$CORE/bin` condicional. `01_exports.sh`: `ANDROID_HOME` cross-platform com auto-detect (macOS/Linux/opt) + override externo. **SRC-01 e R2 já estavam consertados** em commits anteriores (verificados durante essa fase) | ✅ feito |
| **5. Modernização bootstrap** | unificar apt scripts, Brewfile, nave→volta/mise, pip→pipx, remover vendor/rbenv | pendente |
| **6. Cleanup de 50_docker_programs.sh** | **NÃO archive** — adicionar fallback `pinpoint` nas 24 funções que não têm; remover refs a programas mortos (atom) | pendente |
| **7. Testes + CI** | GitHub Actions matrix linux+macos, bats pra PATH e shebangs | pendente |
| **8. Docs finais** | matriz de suporte no README, atualizar trilingual | pendente |

Cada fase em PR/commits separados, reversíveis.

**Importante:** scripts em `bin/pentest`, `bin/games`, `bin/life`, `bin/security`,
`bin/network`, `bin/text` **permanecem no PATH** via `source/01_path.sh`.
Revisão individual via Prompt #43 antes de qualquer archive de subpasta.

---

## 6. Estrutura sugerida pós-cleanup

```
.dotfiles/
├── bin/                # macos/ renomeado de osx_*; pentest/games/life/security
│   ├── dotfiles        # mantidos com scripts revisados e guards de deps
│   ├── macos/          # renomeado de osx_*
│   ├── dev/, files/, games/, life/, network/, pentest/, security/, system/, text/
│   └── ...
├── source/             # consolidado, 1 prompt único
├── init/               # 20_apt unificado, 50_node sem nave, 60_python via pipx
├── packages/           # NOVO — Brewfile, apt.txt, pipx.txt, mise.toml
├── conf/               # macos/ em vez de osx/
├── config/             # XDG configs
├── copy/               # só .example versionados (se dono concordar)
├── link/               # ~/.* symlinks
├── scripts/audit/      # auditorias versionadas
├── test/               # bats + legacy + CI
├── vendor/             # só .tmux (gpakosz)
├── archive/            # NOVO — legacy/, legacy-security/, personal/, docs-2.0/, docs-helper/
└── docs/               # trilingual + audit.md + deprecations.md + scripts-review.md
```

---

## 7. Referências

- [`REVIEW.md`](REVIEW.md) — rodada 1: bugs B1-B2, riscos R1-R4, higiene H1-H3
- [`REVIEW2.md`](REVIEW2.md) — rodada 2: 30 achados em source/, init/, bin/dotfiles
- [`PROMPTS.md`](PROMPTS.md), [`PROMPTS2.md`](PROMPTS2.md) — prompts prontos
- [`deprecations.md`](deprecations.md) — política de depreciação
- [`STRUCTURE_PROMPT.md`](STRUCTURE_PROMPT.md) — meta-prompt da auditoria

Tests + lint: `bash test/run_tests.sh` + `bash scripts/audit/audit_shellcheck.sh`
