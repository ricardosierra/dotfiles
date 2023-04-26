
## Se tiver o codium instalado, preferir invez do code
if [[ "$(which codium)" ]]; then
    EDITOR="codium"
    alias code="$EDITOR"
fi
