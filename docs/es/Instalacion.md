# Instalación

## Requisitos previos

### macOS

Instala primero las herramientas de línea de comandos de Xcode:

```sh
xcode-select --install
```

_Probado en macOS 10.15 (Catalina) y posteriores._

### Linux

Actualiza APT antes de ejecutar el instalador:

```sh
sudo apt-get -qq update && sudo apt-get -qq dist-upgrade
```

_Probado en Ubuntu 14.04 LTS, 16.04 LTS, 22.04 LTS · Debian · KaliLinux 16.10._

---

## Primera instalación (repo bifurcado)

1. Bifurca este repo en GitHub y anota tu nombre de usuario.
2. Abre una terminal y ejecuta:

**macOS:**
```sh
export DOTFILES_GH_USER=tu-usuario-github
export DOTFILES_GH_BRANCH=master
bash -c "$(curl -fsSL https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

**Linux:**
```sh
export DOTFILES_GH_USER=tu-usuario-github
export DOTFILES_GH_BRANCH=master
bash -c "$(wget -qO- https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles) install" && source ~/.bashrc
```

`DOTFILES_GH_USER` solo se necesita en la instalación inicial. Si usas una rama diferente a master, debes exportar `DOTFILES_GH_BRANCH` en ejecuciones posteriores también.

---

## Actualizar (después de la primera instalación)

Simplemente ejecuta:

```sh
dotfiles
```

El comando `dotfiles` vuelve a ejecutar el proceso completo: descarga el último repo, re-copia/re-enlaza archivos y ejecuta cualquier nuevo script de init.

---

## Qué ocurre durante la instalación

| Paso | Acción |
|------|--------|
| 1 | Instalar Git via APT (solo Linux; macOS ya lo incluye) |
| 2 | Clonar repo en `~/.dotfiles` |
| 3 | Copiar archivos de `/copy` a `~/` |
| 4 | Crear enlaces simbólicos de `/link` en `~/` |
| 5 | Elegir qué scripts de `/init` ejecutar (pre-filtrados por SO) |
| 6 | Ejecutar scripts seleccionados en orden alfanumérico |

Cualquier archivo que vaya a ser sobrescrito se respalda en `~/.dotfiles/backups/` primero.

---

## Scripts de init por plataforma

### macOS
- `init/10_osx_xcode.sh` — Xcode Command Line Tools
- `init/20_osx_homebrew.sh` — Homebrew
- `init/30_osx_homebrew_recipes.sh` — Herramientas CLI via Homebrew
- `init/30_osx_homebrew_casks.sh` — Apps GUI via Homebrew Cask
- `init/50_osx_fonts.sh` — Fuentes de programación

### Linux
- `init/20_linux_apt.sh` — Paquetes APT + git-extras

### Ambos
- `init/50_node.sh` — Node.js, npm
- `init/50_ruby.sh` — Ruby, gems, rbenv
- `init/50_vim.sh` — Plugins de Vim

---

## Personalización después de instalar

Agrega archivos directamente en tu home:

- `~/.aliases` — aliases personales
- `~/.exports` — variables de entorno personalizadas
- `~/.path` — entradas extra de PATH
- `~/.gitconfig.local` — identidad git y configuración personal
- `~/.dotfilesconfig.local` — overrides del comportamiento del dotfiles
