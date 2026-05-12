# Dotfiles

> macOS · Ubuntu · Debian · Kali · Fedora  
> Fork do ["Cowboy" Ben Alman](https://github.com/cowboy/dotfiles) — inspirado por [jfrazelle](https://github.com/jfrazelle/dotfiles)

[![tests](https://github.com/ricardorsierra/dotfiles/actions/workflows/tests.yml/badge.svg)](https://github.com/ricardorsierra/dotfiles/actions/workflows/tests.yml)

---

**Documentação / Documentation / Documentación**

| Idioma | Arquivos |
|--------|----------|
| [English](#installation) | [About](docs/en/About.md) · [Install](docs/en/Install.md) · [Folders & Functions](docs/en/dotfiles/FoldersAndFunctions.md) |
| [Português (Brasil)](#instalação) | [Introdução](docs/pt/Introducao.md) · [Funcionamento](docs/pt/Funcionamento.md) · [Personalizando](docs/pt/Personalizando.md) · [Atalhos](docs/pt/usando/Atalhos.md) |
| [Español](#instalación) | [Acerca de](docs/es/Acerca.md) · [Instalación](docs/es/Instalacion.md) · [Carpetas y Funciones](docs/es/dotfiles/CarpetasYFunciones.md) |

**Auditoria de manutenção (2026-Q2):**
[`docs/audit.md`](docs/audit.md) (relatório completo) ·
[`docs/scripts-review.md`](docs/scripts-review.md) (revisão dos 27 scripts em `bin/`) ·
[`docs/deprecations.md`](docs/deprecations.md) (política de archive) ·
[`scripts/audit/`](scripts/audit/) (11 auditorias automatizadas)

---

## Matriz de suporte

| Plataforma | Versão mínima testada | Bootstrap | CI |
|---|---|---|---|
| macOS | 10.15 Catalina+ (Apple Silicon OK) | Homebrew + `init/20_macos_homebrew.sh` + opcional `brew bundle --file=packages/Brewfile` | ✅ |
| Ubuntu | 22.04 LTS (e derivadas: Mint, Pop, Zorin, elementary) | `init/20_apt.sh` unificado | ✅ |
| Debian | 12 (bookworm) | `init/20_apt.sh` | manual |
| Kali Linux | rolling | `init/20_apt.sh` | manual |
| Fedora | 39+ | parcial — Ruby/Python via `dnf` em `init/60_ruby.sh` e `30_python_pip.sh` | — |

CI roda em [GitHub Actions](.github/workflows/tests.yml) com matrix Ubuntu + macOS a cada push.

---

## Aviso importante

Execute este script preferencialmente em um sistema operacional recém-instalado — ele substitui configurações do terminal e outros arquivos que você pode ter personalizado.

**Se você não é o autor deste repo, faça um fork antes de instalar.** O repositório pode estar em estado de transição e causaria problemas no seu sistema.

---

## How the `dotfiles` command works

When [`dotfiles`](bin/dotfiles) is run for the first time:

1. On Ubuntu, Git is installed via APT if necessary (already present on macOS).
2. This repo is cloned to `~/.dotfiles`.
3. Files in `/copy` are copied into `~/`.
4. Files in `/link` are symlinked into `~/`.
5. You choose which `/init` scripts to execute — the installer pre-selects relevant ones based on your OS.
6. Init scripts run in alphanumeric order.

On subsequent runs, step 1 is skipped, step 2 updates the repo, and step 5 remembers previous selections.

### Directory overview

| Directory | Purpose |
|-----------|---------|
| `/.github/workflows` | GitHub Actions CI (matrix Ubuntu + macOS) |
| `/archive` | Código legado opt-in (legacy, legacy-security, personal, docs-2.0) |
| `/backups` | Created automatically — backs up files overwritten by copy/link steps |
| `/bin` | Executable scripts and symlinks, added to `$PATH` |
| `/caches` | Cached data used by scripts and functions |
| `/conf` | Config files that don't belong in `~/` |
| `/copy` | Files copied verbatim into `~/` (use for files with sensitive personal data) |
| `/init` | Install scripts (OS-detected, run once) |
| `/link` | Files symlinked into `~/` (changes in either location affect both) |
| `/packages` | Listas declarativas de pacotes (Brewfile) |
| `/scripts/audit` | 11 scripts de auditoria do repo (uso, deps, segurança) |
| `/source` | Shell files sourced on every new shell, in alphanumeric order |
| `/test` | bats suítes + legacy + shellcheck |
| `/vendor` | Third-party libraries (git submodules: .tmux, git-extras, z, rename) |

### The copy step

Files in `/copy` are copied to `~/`. Use this for files that contain personal data (like `.gitconfig` with your email) — since the copy lives outside `~/.dotfiles`, it won't be accidentally committed.

### The link step

Files in `/link` are symlinked with `ln -s`. Editing either location changes both. Never link files with sensitive data; add them to [`.gitignore`](.gitignore) instead.

### The init step

Scripts in `/init` install software idempotently — only if not already installed.

**macOS:** XCode CLI tools → Homebrew → formulas → casks → fonts  
**Linux (Ubuntu/Debian):** APT packages + git-extras  
**Both:** Node.js + npm · Ruby + rbenv · Vim plugins

---

## Installation

### macOS

Requires [Xcode Command Line Tools](https://developer.apple.com/downloads/):

```sh
xcode-select --install
```

Then install dotfiles:

```sh
export DOTFILES_GH_USER=ricardorsierra
export DOTFILES_GH_BRANCH=master
bash -c "$(curl -fsSL https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

_Tested on macOS 10.15+_

### Linux

```sh
export DOTFILES_GH_USER=ricardorsierra
export DOTFILES_GH_BRANCH=master
bash -c "$(wget -qO- https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

_Tested on Ubuntu 14.04 LTS, 16 LTS, 17 · KaliLinux 16.10_

---

## Shell lint (opt-in)

Scripts `.sh` (e qualquer arquivo com shebang `bash`/`sh`/`zsh`) são lintados automaticamente antes de cada `git push`, usando [shellcheck](https://www.shellcheck.net/). O hook não é ativado por padrão — habilite com:

```sh
./bin/dotfiles-install-hooks
```

- Só linta arquivos **modificados no push** (não o repo todo).
- Submódulos (`link/.oh-my-zsh/`, `link/.tmux/plugins/`) são ignorados.
- Sem `shellcheck` instalado: emite aviso e deixa o push seguir.
- Com erros: aborta o push mostrando arquivo e linha.

Para instalar `shellcheck`: `brew install shellcheck` ou rode o init `30_osx_homebrew_recipes.sh`.

---

## Instalação

### macOS

```sh
export DOTFILES_GH_USER=ricardorsierra
export DOTFILES_GH_BRANCH=master
bash -c "$(curl -fsSL https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

### Linux

```sh
export DOTFILES_GH_USER=ricardorsierra
export DOTFILES_GH_BRANCH=master
bash -c "$(wget -qO- https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

Veja [Personalizando](docs/pt/Personalizando.md) para configurar variáveis e adicionar seus próprios aliases.

---

## Instalación

### macOS

```sh
export DOTFILES_GH_USER=ricardorsierra
export DOTFILES_GH_BRANCH=master
bash -c "$(curl -fsSL https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

Vea [Acerca de](docs/es/Acerca.md) para más información.

---

## Aliases and Functions

`~/.bashrc` and `~/.bash_profile` are minimal and should not need editing. Add custom aliases, functions, and settings to files in the `source/` directory — they are auto-sourced on every new shell.

Useful patterns:
- Personal aliases → `~/.aliases`
- Custom exports → `~/.exports`
- Extra PATH entries → `~/.path`

See [Personalizando](docs/pt/Personalizando.md) for details.

---

## Prompt

The bash prompt ([`source/50_prompt.sh`](source/50_prompt.sh)) shows git/svn status, a timestamp, and exit codes. Colors change based on login method.

Git repos show **[branch:flags]**:

| Flag | Meaning |
|------|---------|
| `?` | Untracked files |
| `!` | Changed but unstaged |
| `+` | Staged files |

---

## Claude Usage Timer

A 5-hour countdown displayed in the tmux status bar to track Claude AI session time.

```
Claude 04h59m | 14:32
```

Color indicates urgency:
- Green — more than 2 hours remaining
- Yellow — 2 hours or less
- Red — 30 minutes or less

**Reset the timer:**
```bash
claude-reset
```

**Sync manually with real usage from the dashboard:**
```bash
claude-set 3h29m 86%
```

### How it works

- [`scripts/claude_timer.sh`](scripts/claude_timer.sh) reads or creates `${XDG_RUNTIME_DIR:-/tmp}/claude_start` (Unix timestamp).
- Computes elapsed time via `date +%s`, outputs `HHhMMm` with tmux color codes.
- Auto-resets if the 5-hour window has expired (stale timer detection).
- Uses `ccusage` for real usage % if available; falls back to manual `claude-set`.
- tmux refreshes every 60 seconds via `status-interval 60`.
- Survives shell restarts; resets on reboot.

---

## Hacking

Because [`dotfiles`](bin/dotfiles) is self-contained, you can delete everything else from your fork and it will still work — it only needs `/copy`, `/link`, and `/init` (ignored if empty or missing).

Found a bug? [File an issue](https://github.com/ricardorsierra/dotfiles/issues) or [open a PR](https://github.com/ricardorsierra/dotfiles/pulls).

---

## Inspiration

- <https://github.com/cowboy/dotfiles>
- <https://github.com/jfrazelle/dotfiles>
- <https://github.com/gf3/dotfiles>
- <https://github.com/mathiasbynens/dotfiles>
