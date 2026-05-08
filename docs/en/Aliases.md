# Complete Alias & Function Reference

Everything available in the shell after installing the dotfiles — aliases, functions, and useful commands.

> **How to use this page:** each section has a table with the alias/function, what it actually does, and an example when useful. The source file is noted in each section header.

---

## Table of Contents

- [Navigation & Files](#navigation--files)
- [Git — Basics](#git--basics)
- [Git — Advanced](#git--advanced)
- [Git Workflow (auto branches)](#git-workflow)
- [Docker](#docker)
- [Docker — Quick Shells](#docker--quick-shells)
- [AWS / ECS](#aws--ecs)
- [Tmux](#tmux)
- [System & Packages](#system--packages)
- [Network](#network)
- [Development](#development)
- [Security](#security)
- [Claude Timer](#claude-timer)
- [Utilities](#utilities)
- [Notes & Tasks](#notes--tasks)
- [Personal Aliases](#personal-aliases)

---

## Navigation & Files

**Source:** `source/50_file.sh`

### Listing

| Alias | Equivalent | Description |
|-------|------------|-------------|
| `ls` | `ls -G` / `ls --color` | Colored listing (detects macOS vs Linux) |
| `l` | `ls -lF` | Long format with colors |
| `la` | `ls -laF` | Includes hidden files (`.`) |
| `ll` | `tree -aLpughDFiC 1` | Visual tree (falls back to `ls -al`) |
| `lsd` | — | Directories only |

### Navigation

| Alias/Function | What it does |
|---------------|--------------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `.....` | `cd ../../../..` |
| `~` | `cd ~` (go home) |
| `-` | `cd -` (previous directory) |
| `dl` | `cd ~/Downloads` |
| `cl [dir]` | `cd` + `ls` in one shot |
| `md <dir>` / `mkd <dir>` | Create directory and enter it |
| `tmpd [prefix]` | Create temp dir in `/tmp` and enter it |
| `z <term>` | Jump to most-visited directory matching term |

### Files

| Alias/Function | What it does |
|---------------|--------------|
| `cp` | `cp -i` — confirms before overwriting |
| `mv` | `mv -i` — confirms before overwriting |
| `untar <file>` | `tar xvf` — extract without memorizing flags |
| `extract <file>` | Detects format and extracts (zip, gz, bz2, rar, 7z, xz…) |
| `targz <dir>` | Creates `.tar.gz` using best available compressor |
| `fs` / `filesize` | File or directory size (human-readable) |
| `df` | `df -h` — disk usage in readable format |
| `dsstore` | Recursively delete all `.DS_Store` files |
| `mine` | `sudo chown -R $USER` — take ownership |
| `map` | `xargs -n1` — apply a command to each item |

### Clipboard (Linux)

| Alias | What it does |
|-------|--------------|
| `pbcopy` | Copy stdin to clipboard |
| `pbpaste` | Paste from clipboard |
| `c` | Strip newlines and copy |
| `cwd` | Copy current directory path |
| `pubkey` | Copy SSH public key |

---

## Git — Basics

**Source:** `source/50_vcs.sh`

| Alias/Function | Equivalent | Description |
|---------------|------------|-------------|
| `g` | `git` | Main shortcut |
| `ga [files]` | `git add .` | Add files (all by default) |
| `gadd` | `git add --all && git status` | Add + show status |
| `gs` / `gst` | `git status` | Repo status |
| `gd` | `git diff` | Working tree diff |
| `gdc` | `git diff --cached` | Staged diff |
| `gl` | `git log` | Simple log |
| `gg` | `git log --graph --oneline --all` | Pretty graph log |
| `gp` / `push` | `git push` | Push |
| `gu` / `pull` | `git pull` | Pull |
| `gpup` | `git push --set-upstream origin <branch>` | Push + set upstream |
| `gpa` | `git push --all` | Push all branches |
| `cmt "msg"` | `git commit -m "msg"` | Commit with message |
| `cmta "msg"` | `git commit -am "msg"` | Add + commit in one shot |
| `gb` | `git branch` | List local branches |
| `gba` | `git branch -a` | All branches (including remotes) |
| `gbup` | — | Set upstream for current branch |
| `gc [branch]` | `git checkout master` | Checkout (master if no arg) |
| `gco` | = `gc` | Alternate alias |
| `gcb <branch>` / `gbc` | `git checkout -b` | Create and enter branch |
| `gr` | `git remote` | Manage remotes |
| `grv` | `git remote -v` | Show remote URLs |
| `grr <remote>` | `git remote rm` | Remove a remote |
| `gcl` | `git clone` | Clone |
| `gcd` | — | Go to repository root |
| `gbs` | — | Current branch name (or SHA in detached HEAD) |
| `gsu` | — | Set upstream for current branch if not set |

---

## Git — Advanced

**Source:** `source/50_vcs.sh`

### Multi-directory commands

| Alias | What it does |
|-------|--------------|
| `gu-all` | `git pull` in all subdirectories |
| `gp-all` | `git push` in all subdirectories |
| `gs-all` | `git status` in all subdirectories |

### GitHub / URLs

| Alias/Function | Description |
|---------------|-------------|
| `gurl [remote]` | Repository URL on GitHub/Bitbucket |
| `gurlp` | URL including current branch + relative path |
| `gpu` | Open current branch in browser |
| `gfu [n]` | Open Nth commit on GitHub (default: last) |
| `gra <user>` | Add GitHub remote by username |
| `repo` | Open repository in browser (GitHub or Bitbucket) |
| `gitio <slug> <url>` | Create short URL on git.io |

### Log with clickable URLs (iTerm)

| Alias | Description |
|-------|-------------|
| `gf [args]` | Log with cmd-clickable URLs in iTerm |
| `gf1` … `gf5` | Last 1 to 5 commits with URLs |

### Advanced functions

| Function | Usage | Description |
|----------|-------|-------------|
| `grbo <parent> [topic]` | `grbo main feature/x` | Rebase topic on top of remote parent |
| `ged [rev1] [rev2]` | `ged HEAD~5` | Open all modified files in editor |
| `gstat [range]` | `gstat HEAD~` | Colored diff combining name-status + stat |
| `git_diff_rename <prev> <new> <old>` | — | Diff of renamed file in GitHub format |
| `git_pr_blaster [n]` | `git_pr_blaster 3` | Create N test PRs to stress CI |

### macOS (Tower / Kaleidoscope)

| Alias/Function | Description |
|---------------|-------------|
| `gt [dir]` | Open repo in Tower |
| `gdk` | Diff in Kaleidoscope |
| `gdkc` | Staged diff in Kaleidoscope |

---

## Git Workflow

**Source:** `source/100_workflow.sh`

Creates standardized branches, commits everything, and pushes — all in one command. Returns to the original branch automatically.

| Alias | Full function | Branch created | Usage |
|-------|---------------|----------------|-------|
| `wd` / `wf` / `wds` | `workflow-demanda-send` | `feature/<name>` | `wd "login screen"` |
| `wf` / `wfs` / `wffs` | `workflow-fix-send` | `fix/<name>` | `wf "broken button"` |
| `wh` / `whs` / `wfhs` | `workflow-hotfix-send` | `hotfix/<name>` | `wh "prod crash"` |
| `wp` / `wfp` | `wfp` | — | Merge feature into dev and push to master |
| `wtu` / `wftu` | `workflow-tag-up` | — | Bump version tag (experimental) |

**Example:**
```bash
wd "login screen"
# → creates feature/login-screen
# → git add . && git commit -am "login screen" && git push
# → returns to original branch
```

---

## Docker

**Source:** `source/30_docker.sh`

### Containers — Run

| Alias/Function | Equivalent | Description |
|---------------|------------|-------------|
| `drun` | `docker run -it --rm` | Interactive, remove on exit |
| `dexec <name>` | — | Open bash (partial name search) |
| `dc` / `docker_exec` | = `dockexec` | Open bash in container |
| `dockexec <id>` | `docker exec -it $@ bash` | Bash by ID |
| `dockexecl` | — | Bash in last container |
| `dex <id>` | `docker exec -it $@ /bin/sh` | sh by ID (for Alpine/BusyBox) |
| `dexl` | — | sh in last container |
| `de <service>` | — | Bash in docker-compose service (uses folder name) |

### Containers — List & Inspect

| Alias | Equivalent | Description |
|-------|------------|-------------|
| `dls` | `docker ps -a` | All containers |
| `dlsl` | `docker ps -l` | Last container |
| `dcount` | `docker ps -qa \| wc -l` | Container count |
| `din` | `docker inspect` | Inspect a container |
| `dinl` | — | Inspect last container |
| `dina` | — | Inspect all containers |
| `dp` / `dport` | `docker port` | Ports of last container |
| `dlog` | `docker logs` | Logs of last container |
| `dl <id>` | `docker logs` | Logs of a container |

### Containers — Start / Stop

| Alias | Description |
|-------|-------------|
| `start` | Start all containers |
| `stop` | Stop all containers |
| `startl` | Start last container |
| `stopl` | Stop last container |
| `dtop <id>` | Stop a specific container |
| `dra` | Stop and remove all (graceful) |
| `drk` | Kill and remove all |

### Containers — Remove

| Alias | Description |
|-------|-------------|
| `dr <id>` | Force remove |
| `drl` | Remove last container |
| `drall` | Remove all containers |
| `delcon <filter>` | Remove containers matching filter |
| `stopcon <filter>` | Stop containers matching filter |

### Images

| Alias/Function | Description |
|---------------|-------------|
| `di` | List images |
| `di5` | Last 5 images |
| `dri <img>` | Remove image |
| `db <tag>` | Build with tag |
| `dbc <tag>` | Build without cache |
| `delnone` | Delete orphan images (`<none>`) |
| `delimg <filter>` | Delete images matching filter |

### Networks

| Alias | Description |
|-------|-------------|
| `dnl` | List networks |
| `dnc` | Create network |
| `dnr` | Remove network |
| `dni` | Inspect network |
| `dnia` | Inspect all networks |
| `dnrm` | Remove all networks |
| `dip <id>` | IP of a container |
| `dipl` | IP of all containers |
| `dnnet` | Subnets and gateways of all networks |

### docker-compose

| Alias | Description |
|-------|-------------|
| `up` | `docker-compose up -d` |
| `down` | `docker-compose down` |
| `docker-restart` | down + rm + up --build |
| `docker-clean` | down + rm |

### Cleanup

| Function | Description |
|----------|-------------|
| `dcleanup` | Remove stopped containers + dangling images |
| `dclean_container` | Remove all containers |
| `dcleanall` | Remove containers + images (everything) |

## Docker — Quick Shells

Ready-to-use OS containers. Those with `rm` in the name are destroyed on exit:

| Alias | OS | Behavior |
|-------|----|----------|
| `alpinerm` | Alpine | Removed on exit |
| `ubunturm` | Ubuntu | Removed on exit |
| `debianrm` | Debian | Removed on exit |
| `fedorarm` | Fedora | Removed on exit |
| `centosrm` | CentOS | Removed on exit |
| `busyrm` | BusyBox | Removed on exit |
| `nethostrm` | Ubuntu (net=host) | Removed on exit |
| `alpine` | Alpine | Stopped on exit |
| `ubuntu` | Ubuntu | Stopped on exit |
| `debian` | Debian | Stopped on exit |
| `alpined` | Alpine | Daemon (background) |
| `ubuntud` | Ubuntu | Daemon (background) |
| `debiand` | Debian | Daemon (background) |

---

## AWS / ECS

**Source:** `source/50_aws.sh`

| Function | Usage | Description |
|----------|-------|-------------|
| `aws-account` | `aws-account` | Current AWS account name |
| `aws-list-clusters` | — | List ECS clusters |
| `aws-list-services <cluster>` | — | Services in a cluster |
| `aws-list-services-by-cluster` | — | All services grouped by cluster |
| `aws-list-tasks <cluster> <svc>` | — | Tasks of a service |
| `aws-list-task-definitions <c> <s>` | — | Task definitions for active tasks |
| `aws-task-definition <c> <s>` | — | Current task definition |
| `aws-task-definition-env <c> <s>` | — | Task env vars (VAR=VALUE format) |
| `aws-task-definition-env-history <td>` | — | History of env var changes |
| `aws-stop-tasks <c> <svc...>` | — | Stop all tasks for a service |
| `aws-logs <group> <stream>` | — | Read CloudWatch Logs with auto-pagination |

---

## Tmux

**Source:** `source/10_tmux.sh`

| Alias/Function | Description |
|---------------|-------------|
| `tls` | List open tmux sessions |
| `tm [args]` | Attach to existing session or create new one; exits shell when tmux closes |
| `qq [n] [dir]` | Open new window in main-vertical layout with N panes |
| `q2` | `qq 2` — 2 panes |
| `q3` | `qq 3` — 3 panes |
| `run_in_fresh_tmux_window <cmd>` | Run command in a fresh window (creates new window if multiple panes) |

**Example:**
```bash
qq 2 ~/Dev/my-project   # window with 2 panes in the project
```

---

## System & Packages

**Source:** `source/50_system.sh`

Unified commands — work on macOS (brew), Debian/Ubuntu (apt), Arch (pacman), RHEL/CentOS (yum):

| Alias | What it does |
|-------|--------------|
| `update` | Update all packages |
| `install <pkg>` | Install a package |
| `remove <pkg>` | Remove a package |
| `search <pkg>` | Search packages |
| `e` | `exit` — exit the shell |
| `ipif <ip\|host>` | Geographic info for an IP or hostname |

---

## Network

**Sources:** `source/50_net.sh`, `source/50_file.sh`

| Alias/Function | What it does |
|---------------|--------------|
| `wanip` | Public IP via OpenDNS |
| `pubip` | Alias for `wanip` |
| `localip` | Local IP (excludes loopback) |
| `ips` | All IPs (IPv4 and IPv6) |
| `whois <domain>` | WHOIS with unified server |
| `flush` | Flush DNS cache (macOS) |
| `httpdump` | Monitor HTTP traffic on en1 |
| `sniff` | Capture GET/POST on en1 |
| `pingtest [host]` | Ping with audio feedback (says "ping" aloud) |
| `digga <domain>` | Clean `dig` showing only the essentials |
| `mwiki <term>` | Wikipedia summary via DNS |
| `getcertnames <domain>` | Show CN and SANs of SSL certificate |

---

## Development

**Sources:** `source/50_developer.sh`, `source/20_system.sh`

| Alias/Function | Usage | Description |
|---------------|-------|-------------|
| `server [port]` | `server 3000` | Local HTTP server (Python, default: 8000) |
| `csource <file.c>` | `csource main.c` | Compile and run C, no leftover binaries |
| `gostatic [dir] [mode]` | `gostatic . netgo` | Static Go binary for Linux |
| `gogo <project>` | `gogo my-app` | Jump to project directory in GOPATH |
| `golistdeps` | — | List external dependencies of Go project |
| `calc "expression"` | `calc "2^10"` | Calculator with 10 decimal places |
| `json <string\|pipe>` | `json '{"x":1}'` | Format and colorize JSON |
| `gz <file>` | `gz bundle.js` | Compare original vs gzipped size |
| `escape "text"` | — | Convert to `\x{XX}` Unicode sequences |
| `codepoint "char"` | `codepoint é` | Unicode code point of a character |
| `v [file]` | `v` | Open vim (current dir if no arg) |
| `o [path]` | `o .` | Open with xdg-open (file manager) |
| `tre [args]` | — | `tree` with colors, hidden files, paged |
| `man <cmd>` | — | Man page with nice colors |
| `diff` | — | `git diff --color-words` (overrides default) |
| `urlencode "str"` | — | URL-encode a string |
| `dataurl <file>` | `dataurl logo.png` | Convert file to base64 Data URL |
| `mergepdf -o out.pdf ...` | — | Merge PDFs (macOS) |
| `GET` / `POST` / etc. | `GET http://...` | HTTP requests from command line |

---

## Security

**Source:** `source/50_security.sh`

> Use only on networks/systems you are authorized to test.

| Function | Description |
|----------|-------------|
| `hostscan` | Ping sweep on an IP range (prompts for range) |
| `portknock <host> <ports...>` | Port knocking via nmap |
| `webscan <host>` | SYN scan + dirbusting (requires root) |
| `zonetransfer` | Attempt DNS zone transfer (prompts for domain) |

---

## Claude Timer

**Sources:** `source/50_misc.sh`, `scripts/claude_timer.sh`, `scripts/claude_set.sh`

The timer appears in the tmux status bar and shows remaining usage window (5h total) + token usage percentage.

| Alias/Script | Usage | Description |
|-------------|-------|-------------|
| `claude-reset` | — | Reset timer and usage percentage |
| `claude-set <time> [%]` | `claude-set 3h29m 86%` | Sync with dashboard values |

**tmux bar colors:**
- Green: more than 2 hours remaining
- Yellow: between 30 min and 2 hours
- Red: less than 30 min

---

## Utilities

**Sources:** `source/50_misc.sh`, `source/20_system.sh`

| Alias/Function | Usage | Description |
|---------------|-------|-------------|
| `loop [delay] <cmd>` | `loop 5 echo "hi"` | Repeat command every N seconds |
| `loopc [delay] 'cmds'` | `loopc 5 'echo a; echo b'` | Same, but accepts multiple commands |
| `timer` | — | Stopwatch (Ctrl-D to stop) |
| `week` | — | Current week number |
| `afk` | — | Lock screen (i3lock black background) |
| `hosts` | — | Edit `/etc/hosts` with sudo |
| `grep` | — | Always colored |
| `titlebar "title"` | — | Change terminal title bar |
| `sudo` | — | Allows using aliases with sudo |
| `dbs [session\|system]` | — | List D-Bus services |
| `isup <url>` | `isup https://mysite.com` | Check if a URL is up |
| `openimage <img>` | — | View images with feh |
| `xname <window-id>` | — | Get X11 window name and class |

---

## Notes & Tasks

**Source:** `source/50_file.sh`

### `note` — Quick notepad at `~/.notes`

```bash
note               # show everything
note my idea       # add a note
note -c            # clear all notes
```

### `todo` — Task list at `~/.todo`

```bash
todo               # show tasks
todo buy milk      # add task
todo -l            # numbered list
todo -r            # remove by number
todo -c            # clear all
```

---

## Personal Aliases

**Source:** `link/.aliases`

| Alias | What it does |
|-------|--------------|
| `m` | `code .` — open VS Code in current directory |
| `c` | `composer` (PHP) |
| `a` | `phpstan analyse` |
| `products` | `cd $DEV_FOLDER_PRODUCTS` |
| `mp` | `cd .../MinhaPeca` |
| `Girls` | `cd .../Girls` |
| `Boss` | `cd .../Boss` |
| `banlek` | `cd .../Banlek` |
| `Novacao` | `cd .../novacao` |
| `eng` | `cd .../eunagarupa` |
| `libs` | `cd $DEV_FOLDER_LIBS` |
| `Tools` | `cd .../Tools` |
| `Facilitador` | `cd .../Facilitador` |
| `rica` | `cd $BUSINESS_FOLDER_ROOT` |
| `docker-restart` | `docker-compose down && rm && up --build` |
| `docker-clean` | `docker-compose down && rm` |

---

*Last updated: May 2026*
