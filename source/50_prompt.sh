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

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

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
bold="\[\e[1m\]";
reset="\[\e[0m\]";
black="\[\e[1;30m\]";
blue="\[\e[1;34m\]";
cyan="\[\e[1;36m\]";
green="\[\e[1;32m\]";
purple="\[\e[1;35m\]";
red="\[\e[1;31m\]";
violet="\[\e[1;35m\]";
white="\[\e[1;37m\]";
yellow="\[\e[1;33m\]";
bracket=$white
error=$red
# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
	reset="${red}";
else
	userStyle="${blue}";
	reset="${blue}";
fi;
# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${blue}";
fi;

# Exit code of previous command.
function prompt_exitcode() {
  [[ $1 != 0 ]] && echo " $c2$1$c9"
}

# Git status.
function prompt_git() {
  local status output
  status="$(git branch 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"

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
  PS1="$PS1${bracket}[${userStyle}\u${bracket}@${hostStyle}\h${bracket}]"

  # date: [HH:MM:SS]
  PS1="$PS1${bracket}[${yellow}$(date +"%H${bracket}:${yellow}%M${bracket}:${yellow}%S")${bracket}]${reset}"

  # [path]
  PS1="$PS1${userStyle}:${cyan}\w${reset}"

  # exit code: 127
  PS1="$PS1${error}$(prompt_exitcode "$exit_code")"
  PS1="$PS1 ${bracket}\$ "

  PS2="${yellow}→ ${reset}";
  export PS2;
}

PROMPT_COMMAND="prompt_command"
