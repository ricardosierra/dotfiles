
#
# Se um comando possui um executavel
# Referencia: https://emmer.dev/blog/reliably-finding-files-in-path/
# pinpoint não funciona no zrc e which -p não no bash. então melhor um que não dependa do terminal
#
pinpoint() {
    while read -r DIR; do
        if [[ -f "${DIR}/$1" ]]; then
            echo "${DIR}/$1"
            return 0
        fi
    done <<< "$(echo "${PATH}" | tr ':' '\n')"
    return 1
}