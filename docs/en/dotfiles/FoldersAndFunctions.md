# Folders and Functions

## How the `dotfiles` command works

When [`dotfiles`](../../../bin/dotfiles) is run for the first time:

1. On Ubuntu, Git is installed via APT if necessary (macOS already has it).
2. This repo is cloned to `~/.dotfiles`.
3. Files in `/copy` are copied to `~/`.
4. Subdirectories in `/copy` are copied to `/`.
5. Files in `/link` are symlinked to `~/`.
6. You choose which `/init` scripts to run — pre-filtered for your OS.
7. Selected init scripts execute in alphanumeric order.

On subsequent runs: step 1 is skipped, step 2 pulls updates, step 6 remembers previous selections.

---

## Directory reference

### `/backups`

Created automatically before the copy and link steps. Any `~/` file that would be overwritten gets moved here first. Safe to inspect or delete.

### `/bin`

Executable scripts and symlinks. This directory is added to `$PATH` automatically.

Key scripts:

| Script | Purpose |
|--------|---------|
| `dotfiles` | Main orchestrator — runs the full install/update cycle |
| `src` | Re-sources all files in `/source` without restarting the shell |
| `browser-exec` | Opens URLs or falls back to a Docker browser image |
| `eachdir` | Runs a command in every immediate subdirectory |

### `/caches`

Cached data used by scripts (e.g., brew bundle cache). Safe to delete — regenerated on next run.

### `/conf`

Config files that reference but don't live in `~/`. For example, OS-specific configs and font files.

### `/copy`

Files copied verbatim to `~/` during install. Use for files containing personal data (email, private keys) that must not end up committed in the public repo. Editing `~/file` does **not** update `~/.dotfiles/copy/file`.

Example: `copy/.gitconfig` contains email + signing key.

### `/link`

Files symlinked to `~/` with `ln -s`. Editing either `~/.dotfiles/link/file` or `~/file` changes both — they are the same file. Never link files with sensitive content; add them to `.gitignore`.

### `/source`

Shell files auto-sourced on every new shell, loaded in alphanumeric order. This is why files are prefixed with numbers (`00_`, `10_`, `50_`, etc.).

Key source files:

| File | Purpose |
|------|---------|
| `00_dotfiles.sh` | Core dotfiles variables and helpers |
| `01_exports.sh` | Environment variable exports |
| `01_path.sh` | PATH configuration |
| `01_prompt.sh` | Prompt variables |
| `10_tmux.sh` | Tmux session helpers |
| `20_system.sh` | OS-level aliases (ls, cd, cp, mv) |
| `30_docker.sh` | Docker and Docker Machine aliases |
| `50_dev.sh` | Development aliases and functions |
| `50_developer.sh` | Extra dev helpers |
| `50_file.sh` | File manipulation shortcuts |
| `50_net.sh` | Network utilities |
| `50_osx.sh` | macOS-specific helpers |
| `100_workflow.sh` | Git workflow commands (gf/jf) |

### `/init`

Install scripts run once per machine (idempotent — skip if already installed). Numbered for execution order.

### `/test`

Unit tests for complex bash functions. Run with the test runner in `/bin`.

### `/vendor`

Third-party libraries included as git submodules (e.g., git-extras, oh-my-zsh, rbenv).

---

## Aliases and functions

`~/.bashrc` and `~/.bash_profile` are intentionally minimal — they just source `/source`. Add your own aliases, functions, and exports in `/source/` files or in personal override files:

| File | Purpose |
|------|---------|
| `~/.aliases` | Personal aliases (auto-sourced) |
| `~/.exports` | Custom environment variables |
| `~/.path` | Extra PATH entries |

For a **complete reference** of all available aliases and functions (Git, Docker, AWS, Tmux, network tools, etc.), see [`docs/en/Aliases.md`](../Aliases.md).

---

## The prompt

[`source/50_prompt.sh`](../../../source/50_prompt.sh) builds a prompt showing:

- Current directory
- Timestamp
- Last exit code (colored red on failure)
- Git/SVN repo status

**Git flags:**

| Flag | Meaning |
|------|---------|
| `?` | Untracked files present |
| `!` | Modified but unstaged |
| `+` | Staged, ready to commit |

**SVN format:** `[rev1:rev2]` where `rev1` = last changed revision, `rev2` = working copy revision.

---

## Scripts overview

Beyond `dotfiles` itself, the `/bin` directory contains utilities:

| Script | Description |
|--------|-------------|
| `dotfiles` | Install/update dotfiles |
| `src` | Re-source shell without restarting |
| `browser-exec` | Open URL in browser or Docker fallback |
| `eachdir` | Run command in each subdirectory |
| `network` | Network diagnostics helper |
| `security` | Security-related utilities |
| `osx_create_installer` | Create macOS bootable installer |
| `rename` | Bulk file renaming |
| `pid` | Find process ID by name |
| `isip` | Test if a string is a valid IP address |
| `manh` / `manp` | Man page helpers |
