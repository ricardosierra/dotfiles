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

## Auditoría de mantenimiento (2026-Q2)

Un ciclo completo de auditoría se ejecutó en este repo para eliminar tooling
legado, modernizar el bootstrap y agregar CI. Salidas principales:

- [`docs/audit.md`](../audit.md) — informe completo (8 fases, 60+ commits)
- [`docs/scripts-review.md`](../scripts-review.md) — revisión de 27 scripts en
  `bin/{pentest,network,system,files,security,life,text}/` + 7 herramientas nuevas
- [`docs/deprecations.md`](../deprecations.md) — política de archive
- [`scripts/audit/`](../../scripts/audit/) — 11 scripts de auditoría reutilizables
- [`archive/`](../../archive/) — código legado en cuarentena (instalador BeEF,
  grabador CDRW, funciones docker muertas atom/phonegap/dcos/tormessenger, etc.)

Nuevas herramientas CLI agregadas en este ciclo (todas en `bin/`):

| Herramienta | Qué hace |
|---|---|
| `port-killer <puerto>` | Mata el proceso escuchando en un puerto (con confirmación) |
| `du-by-extension [dir]` | Top 20 de uso de disco por extensión |
| `wifi-strength` | SSID actual + fuerza de señal (macOS/Linux) |
| `dedupe [dir]` | Lista duplicados por hash MD5 |
| `ssl-check <dominio>` | Audita cert TLS: issuer, validez, días restantes |
| `git-cleanup [--apply]` | Elimina ramas ya mergeadas en main/master/develop |
| `wc-by-language [dir]` | LoC por lenguaje (alternativa ligera a tokei/cloc) |
