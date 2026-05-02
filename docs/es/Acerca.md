# Acerca de este Dotfiles

## ¿Qué es esto?

Este es un repositorio personal de dotfiles — una colección de archivos de configuración de shell, scripts de instalación, aliases y herramientas que reconstruyen un entorno de desarrollo completo desde cero en cualquier máquina.

El objetivo: ejecutar un solo comando en un SO recién instalado y obtener un entorno de terminal completamente configurado y personalizado con todas las herramientas instaladas.

## Historia

Construido sobre más de 15 años de configuración acumulada de shell, originalmente bifurcado del [dotfiles de Cowboy](https://github.com/cowboy/dotfiles) de Ben Alman, con inspiración adicional de [jfrazelle](https://github.com/jfrazelle/dotfiles), [gf3](https://github.com/gf3/dotfiles) y [mathiasbynens](https://github.com/mathiasbynens/dotfiles).

## Qué incluye

- **Configuración del shell** — prompt, aliases, funciones, exports, configuración de PATH
- **Scripts de instalación** — Homebrew (macOS), APT (Linux), Node.js, Ruby, plugins de Vim, fuentes
- **Helpers de Docker** — aliases para gestionar contenedores, imágenes, redes y shells Docker bajo demanda
- **Workflow de Git** — comandos `gf`/`jf` para crear rama, hacer commit y enviar en un solo paso
- **Integración con tmux** — temporizador de sesión Claude y configuración de la barra de estado
- **Gitignore global** — ignora artefactos comunes de compilación, editores y herramientas de IA
- **Personalización de Vim** — plugins y configuraciones via script de init

## Plataformas compatibles

| Plataforma | Estado |
|-----------|--------|
| macOS 10.15+ | Principal |
| Ubuntu 14.04 – 22.04 LTS | Probado |
| Debian | Compatible |
| KaliLinux | Compatible |
| Fedora | Parcial |

## Antes de instalar

Si no eres el autor de este repo, **haz un fork primero** y elimina lo que no necesites. El proceso de instalación modifica `.bashrc`, `.bash_profile` y otros archivos de shell que pueden estar ya personalizados en tu sistema.

Se crean copias de seguridad automáticamente en `~/.dotfiles/backups/` antes de sobrescribir cualquier archivo.

## Más documentación

- [Instalación](Instalacion.md)
- [Carpetas y Funciones](dotfiles/CarpetasYFunciones.md)
