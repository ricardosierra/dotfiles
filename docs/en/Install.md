# Installation

## Prerequisites

### macOS

Install the Xcode Command Line Tools first:

```sh
xcode-select --install
```

_Tested on macOS 10.15 (Catalina) and later._

### Linux

Update APT before running the installer:

```sh
sudo apt-get -qq update && sudo apt-get -qq dist-upgrade
```

_Tested on Ubuntu 14.04 LTS, 16.04 LTS, 22.04 LTS · Debian · KaliLinux 16.10._

---

## First-time install (forked repo)

1. Fork this repo on GitHub and note your username.
2. Open a terminal and run:

**macOS:**
```sh
export DOTFILES_GH_USER=your-github-username
export DOTFILES_GH_BRANCH=master
bash -c "$(curl -fsSL https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

**Linux:**
```sh
export DOTFILES_GH_USER=your-github-username
export DOTFILES_GH_BRANCH=master
bash -c "$(wget -qO- https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

`DOTFILES_GH_USER` is only needed for the initial clone. If you use a non-master branch, set `DOTFILES_GH_BRANCH` on subsequent runs too.

---

## Updating (after first install)

Just run:

```sh
dotfiles
```

The `dotfiles` command re-runs the full process: pulls the latest repo, re-copies/re-links files, and re-runs any new init scripts.

---

## What happens during install

| Step | Action |
|------|--------|
| 1 | Install Git via APT (Linux only; macOS already has it) |
| 2 | Clone repo to `~/.dotfiles` |
| 3 | Copy files from `/copy` to `~/` |
| 4 | Symlink files from `/link` to `~/` |
| 5 | Prompt to choose `/init` scripts (pre-filtered for your OS) |
| 6 | Run selected init scripts in alphanumeric order |

Any files that would be overwritten are backed up to `~/.dotfiles/backups/` first.

---

## Init scripts by platform

### macOS
- `init/10_osx_xcode.sh` — XCode Command Line Tools
- `init/20_osx_homebrew.sh` — Homebrew
- `init/30_osx_homebrew_recipes.sh` — CLI tools via Homebrew
- `init/30_osx_homebrew_casks.sh` — GUI apps via Homebrew Cask
- `init/50_osx_fonts.sh` — Programming fonts

### Linux
- `init/20_linux_apt.sh` — APT packages + git-extras

### Both
- `init/50_node.sh` — Node.js, npm
- `init/50_ruby.sh` — Ruby, gems, rbenv
- `init/50_vim.sh` — Vim plugins

---

## Customizing after install

See [Personalizando](../pt/Personalizando.md) (pt-BR) or add files directly:

- `~/.aliases` — personal aliases
- `~/.exports` — custom environment variables
- `~/.path` — extra PATH entries
- `~/.gitconfig.local` — git identity and personal settings
- `~/.dotfilesconfig.local` — dotfiles behavior overrides
