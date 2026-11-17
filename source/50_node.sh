# source/50_node.sh — Node.js (via volta) + helpers npm/yarn.
# shellcheck shell=bash
#
# Antes: tinha funções nave_* (nave = gerenciador de Node morto desde ~2018) e
# uma npm_globals com phonegap 3.6, cordova 5, ripple-emulator, ember-cli,
# bower, grunt-cli, gulp-cli — tudo fóssil.
# Hoje: só volta + helpers npx + utilitários de busca por arquivo.

# Bail se volta não está instalado e não estamos no init.
[[ "$1" != init && ! -e ~/.volta ]] && return 0

export VOLTA_HOME=~/.volta
grep --silent "$VOLTA_HOME/bin" <<< "$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"

# =============================================================================
# npm — atalhos úteis
# =============================================================================

# rebuild rápido
alias npm_up='npm prune && npm install && npm update'

# roda comando com node_modules/.bin no PATH (sem precisar de npx)
function npm_run() {
  git rev-parse 2>/dev/null && (
    PATH="$(git rev-parse --show-toplevel)/node_modules/.bin:$PATH"
    "$@"
  )
}

# publica módulo — só atualiza "latest" se versão for release (sem pre-release tag)
function npm_publish() {
  local version
  version="$(node -pe 'require("./package.json").version' 2>/dev/null)"
  if [[ "${version#v}" =~ [a-z] ]]; then
    local branch
    branch="$(git branch --show-current 2>/dev/null)"
    echo "Publishing dev version $version with --force --tag=$branch"
    npm publish --force --tag="$branch" "$@"
  else
    echo "Publishing new latest version $version"
    npm publish "$@"
  fi
}

# =============================================================================
# npx aliases — evita instalar global, usa o pacote ad-hoc.
# =============================================================================
function make_npx_alias() {
  alias "$1"="npx $1"
}
make_npx_alias json2yaml
make_npx_alias pushstate-server
make_npx_alias yaml2json

# =============================================================================
# Helpers de "watch" — encontra arquivo mais recente e roda yarn watch nele.
# =============================================================================
function get_last_modified_js_file_recursive() {
  local stat_fmt
  if [[ "$(uname)" == "Darwin" ]]; then
    stat_fmt=(-f '%m %N')
  else
    stat_fmt=(-c '%Y %n')
  fi
  find . -type d \( -name node_modules -o -name .git -o -name .build \) -prune -o \
    -type f \( -name '*.js' -o -name '*.jsx' \) -print0 |
    xargs -0 stat "${stat_fmt[@]}" |
    sort -rn |
    head -1 |
    cut -d' ' -f2-
}

function watchfile() {
  yarn watch --testPathPattern \
    "$(get_last_modified_js_file_recursive | sed -E 's#.*/([^/]+)/([^.]+).*#\1/\2.#')"
}

function watchdir() {
  yarn watch --testPathPattern "$(dirname "$(get_last_modified_js_file_recursive)")"
}
