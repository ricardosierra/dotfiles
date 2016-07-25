# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][sierra@pcDoSierra][17:17:12]:~/Development/Projects $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/ricardorsierra/dotfiles

# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white

# DEFAULT COLORS
if [[ ! "${reset}" ]]; then

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    reset="\[\e[32m\]"
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    reset="\[\e[35m\]"
  else
    # logged in as default user
    reset="\[\e[36m\]"
  fi

  bracket="\[\e[37m\]"
  error="\[\e[31m\]"

  green="\[\e[32m\]"
  magenta="\[\e[35m\]"
  blue="\[\e[34m\]"
  cyan="\[\e[36m\]"
  white="\[\e[37m\]"
  yellow="\[\e[33m\]"
  purple="\[\e[35m\]"
  bold=$(tput bold)
fi

# Exit code of previous command.
function prompt_exitcode() {
  [[ $1 != 0 ]] && echo " $c2$1$c9"
}

# Git status.
function prompt_git() {
  local status output flags branch
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
        /^(# )?Changes to be committed:$/        {r=r "+"}\
        /^(# )?Changes not staged for commit:$/  {r=r "!"}\
        /^(# )?Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output${bracket}:${reset}$flags"
  fi
  echo "${bracket}[${green}${output}${bracket}]$c9"
}

# hg status.
function prompt_hg() {
  local summary output bookmark flags
  summary="$(hg summary 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$summary" | awk '/branch:/ {print $2}')"
  bookmark="$(echo "$summary" | awk '/bookmarks:/ {print $2}')"
  flags="$(
    echo "$summary" | awk 'BEGIN {r="";a=""} \
      /(modified)/     {r= "+"}\
      /(unknown)/      {a= "?"}\
      END {print r a}'
  )"
  output="$output:$bookmark"
  if [[ "$flags" ]]; then
    output="$output${bracket}:${reset}$flags"
  fi
  echo "${bracket}[${reset}$output${bracket}]$c9"
}

# SVN info.
function prompt_svn() {
  local info="$(svn info . 2> /dev/null)"
  local last current
  if [[ "$info" ]]; then
    last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
    current="$(echo "$info" | awk '/Revision:/ {print $2}')"
    echo "${bracket}[${reset}$last${bracket}:${reset}$current${bracket}]$c9"
  fi
}

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  # http://twitter.com/cowboy/status/150254030654939137
  PS1="\n"

  # svn: [repo:lastchanged]
  PS1="$PS1$(prompt_svn)"

  # git: [branch:flags]
  PS1="$PS1$(prompt_git)"

  # hg:  [branch:flags]
  PS1="$PS1$(prompt_hg)"

  # misc: [cmd#:hist#]
  #PS1="$PS1${bracket}[${reset}#\#${bracket}:${reset}!\!${bracket}]$c9"

  # [user@host:path]
  PS1="$PS1${bracket}[${reset}\u${bracket}@${reset}\h${bracket}]"

  # date: [HH:MM:SS]
  PS1="$PS1${bracket}[${yellow}$(date +"%H${bracket}:${yellow}%M${bracket}:${yellow}%S")${bracket}]${reset}"

  # [path]
  PS1="$PS1:${reset}\w${reset}"
  
  # exit code: 127
  PS1="$PS1$(prompt_exitcode "$exit_code")"
  PS1="$PS1 ${bracket}\$ "
}

PROMPT_COMMAND="prompt_command"
