#!/bin/bash

# Ubuntu desktop-only stuff. Abort if not Ubuntu desktop.
is_windows || return 1

alias git="/c/Program\ Files/Git//bin/git.exe"
alias docker-compose="/c/Program Files/Docker Toolbox/docker-compose.exe"