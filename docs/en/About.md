# About This Dotfiles

## What is this?

This is a personal dotfiles repository — a collection of shell configuration files, install scripts, aliases, and tools that rebuild a full development environment from scratch on any machine.

The goal: run one command on a fresh OS and get a fully configured, personalized terminal environment with all tools installed.

## History

Built over 15+ years of accumulated shell configuration, originally forked from [Cowboy's dotfiles](https://github.com/cowboy/dotfiles) by Ben Alman, with additional inspiration from [jfrazelle](https://github.com/jfrazelle/dotfiles), [gf3](https://github.com/gf3/dotfiles), and [mathiasbynens](https://github.com/mathiasbynens/dotfiles).

## What's included

- **Shell configuration** — prompt, aliases, functions, exports, PATH setup
- **Install scripts** — Homebrew (macOS), APT (Linux), Node.js, Ruby, Vim plugins, fonts
- **Docker helpers** — aliases for container management, image inspection, network operations, and on-demand OS shells
- **Git workflow** — `gf`/`jf` commands for feature branch create-commit-push in one shot
- **tmux integration** — Claude session timer, status bar configuration
- **Global gitignore** — ignores common build artifacts, editor files, and AI tool caches
- **Vim customization** — plugins and settings via init script

## Platforms supported

| Platform | Status |
|----------|--------|
| macOS 10.15+ | Primary |
| Ubuntu 14.04 – 22.04 LTS | Tested |
| Debian | Compatible |
| KaliLinux | Compatible |
| Fedora | Partial |
| Windows (Git Bash) | Limited |

## Before you install

If you're not the author of this repo, **fork it first** and remove anything you don't want. The install process modifies `.bashrc`, `.bash_profile`, and other shell files that may already be customized on your system.

Backups are created automatically in `~/.dotfiles/backups/` before any file is overwritten.

## More documentation

- [Installation](Install.md)
- [Folders & Functions](dotfiles/FoldersAndFunctions.md)
