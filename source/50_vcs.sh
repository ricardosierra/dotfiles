
# =============================================================================
# Git — atalhos e funções
# =============================================================================

# atalho principal: g ao invés de git
alias g='git'

# ga: adiciona arquivos (passa tudo por padrão se não informar nada)
function ga() { git add "${@:-.}"; }

# push / pull simples
alias gp='git push'
alias pull='git pull'
alias push='git push'

# adiciona tudo e mostra status de uma vez
alias gadd='git add --all && git status'

# push e já seta o upstream pro branch atual
alias gpup='gp --set-upstream origin $(gbs)'

# push de todos os branches de uma vez
alias gpa='gp --all'

# pull rápido
alias gu='git pull'

# log
alias gl='git log'

# log bonito com grafo, decoração e todas as branches
alias gg='gl --decorate --oneline --graph --date-order --all'

# status
alias gs='git status'
alias gst='gs'

# diff entre working tree e staged
alias gd='git diff'

# diff do que já está staged (pronto pra commit)
alias gdc='gd --cached'

# cmt: commita com a mensagem que você passar direto
# uso: cmt "mensagem aqui"
function cmt() {
    git commit -m "$*"
}

# cmta: faz add de todos os tracked + commit numa tacada só
function cmta() {
    git commit -am "$*"
}

# branches
alias gb='git branch'
alias gba='git branch -a'  # todas as branches, inclusive remotas

# seta upstream do branch atual pro origin
alias gbup='gb --set-upstream-to=origin/$(gbs) $(gbs)'

# checkout (vai pro master se não passar nada)
function gc() { git checkout "${@:-master}"; }
alias gco='gc'
alias gcb='gc -b'   # cria e entra no branch
alias gbc='gc -b'   # alias pra dyslexia :)

# remotes
alias gr='git remote'
alias grv='gr -v'            # mostra as URLs dos remotes
alias grr='git remote rm'    # remove um remote
alias gcl='git clone'

# vai pra raiz do repositório (vai pro topo da árvore)
alias gcd='git rev-parse 2>/dev/null && cd "./$(git rev-parse --show-cdup)"'

# pega o nome do branch atual (ou o SHA se estiver em detached HEAD)
alias gbs='git branch | perl -ne '"'"'/^\* (?:\(detached from (.*)\)|(.*))/ && print "$1$2"'"'"''

# roda comandos em todos os subdiretórios (útil em monorepos)
alias gu-all='eachdir git pull'
alias gp-all='eachdir git push'
alias gs-all='eachdir git status'

# gsu: seta o upstream do branch atual caso ainda não tenha
function gsu() {
  local branch_name=$(git symbolic-ref --short HEAD)
  [[ ! "$branch_name" ]] && echo 'Error: current git branch not detected' && return 1
  local upstream="$(git config "branch.$branch_name.merge")"
  [[ "$upstream" ]] && echo "Upstream for branch '$branch_name' already set." && return
  git branch --set-upstream-to=origin/$branch_name $branch_name
}

# grbo: rebaseia um branch de feature em cima do parent remoto
# útil quando o branch pai avançou e você precisa atualizar o filho
# uso: grbo parent-branch [topic-branch]
function grbo() {
  local parent topic parent_sha origin_sha
  parent=$1
  topic=$2
  [[ ! "$parent" ]] && _grbo_err "Missing parent branch." && return 1
  parent_sha=$(git rev-parse $parent 2>/dev/null)
  [[ $? != 0 ]] && _grbo_err "Invalid parent branch: $parent" && return 1
  origin_sha=$(git ls-remote origin $parent | awk '{print $1}')
  [[ ! "$origin_sha" ]] && _grbo_err "Invalid origin parent branch: origin/$parent" && return 1
  [[ "$parent_sha" == "$origin_sha" ]] && echo "Same SHA for parent and origin/parent. Nothing to do!" && return
  if [[ "$topic" ]]; then
    git rev-parse "$topic" >/dev/null 2>&1
    [[ $? != 0 ]] && _grbo_err "Invalid topic branch: $topic" && return 1
  else
    topic="$(git rev-parse --abbrev-ref HEAD)"
  fi
  [[ "$topic" == "HEAD" ]] && _grbo_err "Missing or invalid topic branch." && return 1
  [[ "$topic" == "$parent" ]] && _grbo_err "Topic and parent branch must be different!" && return 1
  read -n 1 -r -p "About to rebase $topic onto origin/$parent. Are you sure? [y/N] "
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    git fetch &&
    git rebase --onto origin/$parent $parent "$topic" &&
    git branch -f $parent origin/$parent
  else
    echo "Aborted by user."
  fi
}
function _grbo_err() {
  echo "Error: $@"
  echo "Usage: grbo parent-branch [topic-branch]"
}

# ged: abre no editor todos os arquivos modificados (que ainda existem)
# sem argumentos: abre arquivos unstaged/untracked
# com 1 arg: abre arquivos modificados desde aquele commit
# com 2 args: abre arquivos modificados entre os dois commits
function ged() {
  local files
  local _IFS="$IFS"
  IFS=$'\n'
  files=($(git diff --name-status "$@" | grep -v '^D' | cut -f2 | sort | uniq))
  if [[ "$2" ]]; then
    echo "Opening files modified between $1 and $2"
  else
    files+=($(git ls-files --others --exclude-standard))
    if [[ "$1" ]]; then
      echo "Opening files modified since $1"
    else
      echo "Opening unstaged/untracked modified files"
    fi
  fi
  IFS="$_IFS"
  gcd
  if [[ "$(which code)" ]]; then
    code "$(git rev-parse --show-toplevel)" -n "${files[@]}"
  else
    q "${files[@]}"
  fi
  cd - > /dev/null
}

# gra: adiciona um remote do GitHub pelo username
# uso: gra <usuario-github>
function gra() {
  if (( "${#@}" != 1 )); then
    echo "Usage: gra githubuser"
    return 1;
  fi
  local repo=$(gr show -n origin | perl -ne '/Fetch URL: .*github\.com[:\/].*\/(.*)/ && print $1')
  gr add "$1" "git://github.com/$1/$repo"
}

# gurl: pega a URL do GitHub/Bitbucket do repo atual
function gurl() {
  local remotename="${@:-origin}"
  local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local host="$(echo "$remote" | perl -pe 's/.*@//;s/:.*//')"
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  echo "https://$host/$user_repo"
}

# gurlp: URL do repo incluindo branch atual + path relativo (ótimo pra colar em PR)
alias gurlp='echo $(gurl)/tree/$(gbs)/$(git rev-parse --show-prefix)'

# gf: log com URLs clicáveis no iTerm (cmd+click abre o arquivo no GitHub)
function gf() {
  git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
    /^[MA]\t/ {printf "%s\t$(gurl)/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
  )" | less -F
}

# gfu: abre o último commit no GitHub no browser
# uso: gfu [n] — abre o N-ésimo commit (padrão: 1 = último)
function gfu() {
  local n="${@:-1}"
  n=$((n-1))
  git web--browse  $(git log -n 1 --skip=$n --pretty=oneline | awk "{printf \"$(gurl)/commit/%s\", substr(\$1,1,7)}")
}

# gpu: abre o branch atual + path no GitHub no browser
alias gpu='git web--browse $(gurlp)'

# gf1..gf5: atalhos pra ver os últimos N commits com URLs
for n in {1..5}; do alias gf$n="gf -n $n"; done

# gj: navega entre arquivos com conflito de merge via git-jump
function gj() { git-jump "${@:-next}"; }
alias gj-='gj prev'

# gstat: combina diff --name-status com --stat, colorido e bonito
function gstat() {
  local file mode modes color lines range code line_regex
  local file_len graph_len e r c
  range="${1:-HEAD~}"
  echo "Diff name-status & stat for range: $range"
  OLDIFS=$IFS
  IFS=$'\n'

  lines=($(git diff --name-status "$range"))
  code=$?; [[ $code != 0 ]] && return $code
  declare -A modes
  for line in "${lines[@]}"; do
    file="$(echo $line | cut -f2)"
    mode=$(echo $line | cut -f1)
    modes["$file"]=$mode
  done

  file_len=0
  lines=($(git diff -M --stat --stat-width=999 "$range"))
  line_regex='s/\s*([^|]+?)\s*\|.*/$1/'
  for line in "${lines[@]}"; do
    file="$(echo "$line" | perl -pe "$line_regex")"
    (( ${#file} > $file_len )) && file_len=${#file}
  done
  graph_len=$(($COLUMNS-$file_len-10))
  (( $graph_len <= 0 )) && graph_len=1

  lines=($(git diff -M --stat --stat-width=999 --stat-name-width=$file_len \
    --stat-graph-width=$graph_len --color "$range"))
  e=$(echo -e "\033")
  r="$e[0m"
  declare -A c=([M]="1;33" [D]="1;31" [A]="1;32" [R]="1;34")
  for line in "${lines[@]}"; do
    file="$(echo "$line" | perl -pe "$line_regex")"
    if [[ "$file" =~ \{.+\=\>.+\} ]]; then
      mode=R
      line="$(echo "$line" | perl -pe "s/(^|=>|\})/$r$e[${c[R]}m\$1$r$e[${c[A]}m/g")"
      line="$(echo "$line" | perl -pe "s/(\{)/$r$e[${c[R]}m\$1$r$e[${c[D]}m/")"
    else
      mode=${modes["$file"]}
      color=0; [[ "$mode" ]] && color=${c[$mode]}
      line="$e[${color}m$line"
    fi
    echo "$line" | sed "s/\|/$e[0m$mode \|/"
  done
  IFS=$OLDIFS
}

# git_diff_rename: gera diff formatado pra PR quando você renomeou/deletou arquivo
# pipe pra pbcopy pra copiar como bloco de detalhes do GitHub
# uso:
#   git_diff_rename src/Novo.jsx master src/Antigo.jsx
function git_diff_rename() {
  local prev_commit="$1"
  local before="$3"
  local after="$2"
  if [ -p /dev/stdout ]; then
    echo -en "<details>\n  <summary>Diff of <code>$before</code> -> <code>$after</code></summary>\n\n"
    echo -en 'Command:\n```sh\n'
    echo git diff $prev_commit:"$before" HEAD:"$after"
    echo -en '```\n\nDiff:\n```diff\n'
  fi
  git diff $prev_commit:"$before" HEAD:"$after"
  if [ -p /dev/stdout ]; then
    echo -en '```\n</details>\n'
  fi
}

# git_pr_blaster: cria N PRs de teste pra estressar o CI (padrão: 5)
# cria branches temporários, faz push, abre no browser e deleta local
function git_pr_blaster() {
  local i new_branch branch="$(gbs)"
  for i in $(seq 1 ${1:-5}); do
    new_branch="$branch-test-do-not-merge-$i"
    git checkout -b "$new_branch" && \
      echo "$new_branch" >> TEST_PR_DO_NOT_MERGE.txt && \
      git add . && \
      git commit -m "$new_branch" && \
      git push --no-verify && \
      git checkout - && \
      git branch -D "$new_branch" && \
      open "$(gurl)/pull/new/$new_branch"
  done
}

# aliases específicos pra macOS com suporte a ferramentas visuais
if is_osx; then
  alias gdk='git ksdiff'        # abre diff no Kaleidoscope
  alias gdkc='gdk --cached'     # diff staged no Kaleidoscope
  function gt() {
    local path repo
    {
      pushd "${1:-$PWD}"
      path="$PWD"
      repo="$(git rev-parse --show-toplevel)"
      popd
    } >/dev/null 2>&1
    if [[ -e "$repo" ]]; then
      echo "Opening git repo $repo."
      gittower "$repo"   # abre no Tower (app Git visual)
    else
      echo "Error: $path is not a git repo."
    fi
  }
fi

# sobrescreve o diff padrão com o diff colorido do git (só se git estiver disponível)
hash git &>/dev/null
if [ $? -eq 0 ]; then
	diff() {
		git diff --no-index --color-words "$@"
	}
fi

# gitio: cria uma URL curta no git.io
# uso: gitio meu-slug https://github.com/...
gitio() {
	if [ -z "${1}" -o -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`"
		return 1
	fi
	curl -i http://git.io/ -F "url=${2}" -F "code=${1}"
}

# repo: abre o repositório atual no GitHub/Bitbucket no browser
# detecta automaticamente se é Bitbucket pra usar a URL correta
repo() {
	local giturl=$(git config --get remote.origin.url | sed 's/git@/\/\//g' | sed 's/.git$//' | sed 's/https://g' | sed 's/:/\//g')
	if [[ $giturl == "" ]]; then
		echo "Not a git repository or no remote.origin.url is set."
	else
		local gitbranch=$(git rev-parse --abbrev-ref HEAD)
		local giturl="http:${giturl}"

		if [[ $gitbranch != "master" ]]; then
			if echo "${giturl}" | grep -i "bitbucket" > /dev/null ; then
				local giturl="${giturl}/branch/${gitbranch}"
			else
				local giturl="${giturl}/tree/${gitbranch}"
			fi
		fi

		echo $giturl
		open $giturl
	fi
}
