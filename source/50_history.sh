# History settings

# Allow re-editing failed history substitutions and verify history expansions.
if [[ -n "${ZSH_VERSION:-}" ]]; then
  # Zsh has no histreedit equivalent.
  setopt HIST_VERIFY HIST_IGNORE_SPACE HIST_IGNORE_DUPS
  HIST_STAMPS='yyyy-mm-dd'
else
  shopt -s histreedit histverify
  HISTCONTROL=ignoreboth
  HISTTIMEFORMAT='[%F %T] '
  HISTIGNORE=' *:ls:cd:cd -:pwd:exit:date:* --help:* -h:pony:pony add *:pony update *:pony save *:pony ls:pony ls *'
  export HISTCONTROL HISTTIMEFORMAT HISTIGNORE
fi

# Larger shell history (allow 32³ entries; default is 500).
export HISTSIZE=50000000;
if [[ -n "${ZSH_VERSION:-}" ]]; then
  export SAVEHIST=$HISTSIZE
else
  export HISTFILESIZE=$HISTSIZE
fi


# Easily re-execute the last history command.
alias r="fc -s"
