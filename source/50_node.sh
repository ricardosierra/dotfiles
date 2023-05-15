[[ "$1" != init && ! -e ~/.volta ]] && return 1

export PATH="~/.nave/installed/default/bin:$PATH"
#PATH=~/.nave/installed/default/bin:"$(path_remove ~/.nave/installed/*/bin)"

# Set a specific version of node as the "default" for "nave use default"
function nave_default() {
  local version
  local default=${NAVE_DIR:-$HOME/.nave}/installed/default
  [[ ! "$1" ]] && echo "Specify a node version or \"stable\"" && return 1
  [[ "$1" == "stable" ]] && version=$(nave stable) || version=${1#v}
  rm "$default" 2>/dev/null
  echo "$version"
  echo "$default"
  ln -s $version "$default"
  echo "Nave default set to $version"
}

# Install a version of node, set as default, install npm modules, etc.
function nave_install() {
  local version
  [[ ! "$1" ]] && echo "Specify a node version or \"stable\"" && return 1
  [[ "$1" == "stable" ]] && version=$(nave stable) || version=${1#v}
  if [[ ! -d "${NAVE_DIR:-$HOME/.nave}/installed/$version" ]]; then
    e_header "Installing Node.js $version"
    nave install $version
  fi
  [[ "$1" == "stable" ]] && nave_default stable && npm_install
}

# Use the version of node in the local .nvmrc file
alias nvmrc='exec nave use $(<.nvmrc)'

# Global npm modules to install.
npm_globals=(
  babel-cli
  bower
  less
  sass
  gulp-cli
  ember-cli
  eslint
  json-lint
  json2yaml
  grunt-cli
  gulp-cli
  pushstate-server
  phonegap@3.6.0-0.21.19
  cordova@5.0.0
  ripple-emulator@0.9.24
  tns-android
  yo
  webpack
  yaml2json
  yarn
)

# Because "rm -rf node_modules && npm install" takes WAY too long. Not sure
# if this really works as well, though. We'll see.
alias npm_up='npm prune && npm install && npm update'

# Run arbitrary command with npm "bin" directory in PATH.
function npm_run() {
  git rev-parse 2>/dev/null && (
    PATH="$(git rev-parse --show-toplevel)/node_modules/.bin:$PATH"
    "$@"
  )
}

# Update npm and install global modules.
function npm_install() {
  local installed modules
  e_header "Updating npm"
  sudo npm update -g npm
  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } >/dev/null
  modules=($(setdiff "${npm_globals[*]}" "${installed[*]}"))
  if (( ${#modules[@]} > 0 )); then
    e_header "Installing Npm modules: ${modules[*]}"
    # if is_windows; then
    #   npm install -g "${modules[@]}"
    # else
      sudo npm install -g "${modules[@]}"
    # fi
  fi
}

# Publish module to Npm registry, but don't update "latest" unless the version
# is an actual release version!
function npm_publish() {
  local version="$(node -pe 'require("./package.json").version' 2>/dev/null)"
  if [[ "${version#v}" =~ [a-z] ]]; then
    local branch="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
    echo "Publishing dev version $version with --force --tag=$branch"
    npm publish --force --tag="$branch" "$@"
  else
    echo "Publishing new latest version $version"
    npm publish "$@"
  fi
}

# Crazy-ass, cross-repo npm linking.

# Inter-link all projects, where each project exists in a subdirectory of
# the current parent directory. Uses https://github.com/cowboy/node-linken
alias npm_linkall='eachdir "rm -rf node_modules; npm install"; linken */ --src .'
alias npm_link='rm -rf node_modules; npm install; linken . --src ..'

# Link this project's grunt stuff to the in-development grunt stuff.
alias npm_link_grunt='linken . --src ~/gruntjs'

# Print npm owners in subdirectories.
alias npm_owner_list='eachdir "npm owner ls 2>/dev/null | sort"'

# Add npm owners to projects in subdirectories.
function npm_owner_add() {
  local users=
  local root="$(basename $(pwd))"
  [[ $root == "gruntjs" ]] && users="cowboy tkellen"
  if [[ -n "$users" ]]; then
    eachdir "__npm_owner_add_each $users"
  fi
}
export VOLTA_HOME=~/.volta
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

# Use npx instead of installing global npm modules
function make_npx_alias () {
  alias $1="npx $@"
}

make_npx_alias json2yaml
make_npx_alias pushstate-server
make_npx_alias yaml2json

function get_last_modified_js_file_recursive() {
  find . -type d \( -name node_modules -o -name .git -o -name .build \) -prune -o -type f \( -name '*.js' -o -name '*.jsx' \) -print0 \
    | xargs -0 stat -f '%m %N' \
    | sort -rn \
    | head -1 \
    | cut -d' ' -f2-
}

function watchfile() {
  yarn watch --testPathPattern "$(get_last_modified_js_file_recursive | sed -E 's#.*/([^/]+)/([^.]+).*#\1/\2.#')"
}

function watchdir() {
  yarn watch --testPathPattern "$(dirname "$(get_last_modified_js_file_recursive)")"
}
