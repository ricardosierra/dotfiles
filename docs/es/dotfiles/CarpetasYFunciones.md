# Carpetas y Funciones

## Cómo funciona el comando `dotfiles`

Cuando [`dotfiles`](../../../bin/dotfiles) se ejecuta por primera vez:

1. En Ubuntu, Git se instala via APT si es necesario (macOS ya lo tiene).
2. El repo se clona en `~/.dotfiles`.
3. Los archivos de `/copy` se copian en `~/`.
4. Los subdirectorios de `/copy` se copian en `/`.
5. Los archivos de `/link` se enlazan simbólicamente en `~/`.
6. Eliges qué scripts de `/init` ejecutar — pre-filtrados por SO.
7. Los scripts seleccionados se ejecutan en orden alfanumérico.

En ejecuciones posteriores: el paso 1 se omite, el paso 2 actualiza el repo, y el paso 6 recuerda las selecciones anteriores.

---

## Referencia de directorios

### `/backups`

Se crea automáticamente antes de los pasos copy y link. Cualquier archivo de `~/` que vaya a ser sobrescrito se mueve aquí primero. Se puede inspeccionar o eliminar con seguridad.

### `/bin`

Scripts ejecutables y enlaces simbólicos. Este directorio se agrega a `$PATH` automáticamente.

Scripts principales:

| Script | Descripción |
|--------|------------|
| `dotfiles` | Orquestador principal — ejecuta el ciclo completo de instalación/actualización |
| `src` | Vuelve a cargar todos los archivos de `/source` sin reiniciar el shell |
| `browser-exec` | Abre URLs en el navegador o usa una imagen Docker de browser como fallback |
| `eachdir` | Ejecuta un comando en cada subdirectorio inmediato |

### `/caches`

Datos en caché usados por scripts. Se puede eliminar — se regenera en la próxima ejecución.

### `/conf`

Archivos de configuración que no viven en `~/`. Por ejemplo, configuraciones específicas de SO y archivos de fuentes.

### `/copy`

Archivos copiados literalmente a `~/` durante la instalación. Úsalo para archivos con datos personales (email, claves privadas) que no deben aparecer en el repo público. Editar `~/archivo` **no** actualiza `~/.dotfiles/copy/archivo`.

### `/link`

Archivos enlazados en `~/` con `ln -s`. Editar `~/.dotfiles/link/archivo` o `~/archivo` cambia ambos — son el mismo archivo. Nunca enlaces archivos con contenido sensible; agrégalos al `.gitignore`.

### `/source`

Archivos shell cargados automáticamente en cada nuevo shell, en orden alfanumérico. Por eso los archivos tienen prefijos numéricos (`00_`, `10_`, `50_`, etc.).

Archivos principales:

| Archivo | Descripción |
|---------|------------|
| `00_dotfiles.sh` | Variables core y helpers del dotfiles |
| `01_exports.sh` | Exports de variables de entorno |
| `01_path.sh` | Configuración del PATH |
| `01_prompt.sh` | Variables del prompt |
| `10_tmux.sh` | Helpers de sesión tmux |
| `20_system.sh` | Aliases de sistema (ls, cd, cp, mv) |
| `30_docker.sh` | Aliases Docker y Docker Machine |
| `50_dev.sh` | Aliases y funciones de desarrollo |
| `50_file.sh` | Atajos de manipulación de archivos |
| `50_net.sh` | Utilidades de red |
| `50_osx.sh` | Helpers específicos de macOS |
| `100_workflow.sh` | Comandos de workflow Git (gf/jf) |

### `/init`

Scripts de instalación ejecutados una vez por máquina (idempotentes — omiten lo que ya está instalado). Numerados para controlar el orden.

### `/test`

Tests unitarios para funciones bash complejas.

### `/vendor`

Librerías de terceros incluidas como submódulos git (ej: git-extras, oh-my-zsh, rbenv).

---

## Aliases y funciones

`~/.bashrc` y `~/.bash_profile` son intencionalmente mínimos — solo cargan `/source`. Agrega tus propios aliases, funciones y exports en archivos de `/source/` o en archivos de override personales:

| Archivo | Descripción |
|---------|------------|
| `~/.aliases` | Aliases personales (cargados automáticamente) |
| `~/.exports` | Variables de entorno personalizadas |
| `~/.path` | Entradas extra de PATH |

---

## El prompt

[`source/50_prompt.sh`](../../../source/50_prompt.sh) construye un prompt que muestra:

- Directorio actual
- Timestamp
- Último código de salida (rojo en fallo)
- Estado del repo Git/SVN

**Flags Git:**

| Flag | Significado |
|------|------------|
| `?` | Archivos sin seguimiento |
| `!` | Modificados pero sin staging |
| `+` | En staging, listos para commit |

---

## Referencia de scripts en `/bin`

| Script | Descripción |
|--------|------------|
| `dotfiles` | Instalar/actualizar dotfiles |
| `src` | Recargar shell sin reiniciar |
| `browser-exec` | Abrir URL en navegador o Docker |
| `eachdir` | Ejecutar comando en cada subdirectorio |
| `network` | Diagnósticos de red |
| `security` | Utilidades de seguridad |
| `osx_create_installer` | Crear instalador de arranque de macOS |
| `rename` | Renombrado masivo de archivos |
| `pid` | Buscar ID de proceso por nombre |
| `isip` | Comprobar si una cadena es una IP válida |
| `manh` / `manp` | Helpers de páginas man |
