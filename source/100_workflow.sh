
# =============================================================================
# Workflow Git — cria branches padronizados e faz push numa tacada só
# =============================================================================
# Padrão de branches usado aqui:
#   feature/<nome>  — nova funcionalidade
#   fix/<nome>      — correção de bug comum
#   hotfix/<nome>   — correção urgente em produção
#
# Todos os comandos:
#   1. Memorizam o branch atual
#   2. Criam o branch novo no padrão correto
#   3. Fazem add + commit + push
#   4. Voltam pro branch original automaticamente

# wd / wf / wds: cria branch feature/<nome>, commita tudo e faz push
alias wfds="workflow-demanda-send"
alias wds="workflow-demanda-send"
alias wd="workflow-demanda-send"
function workflow-demanda-send() {
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"
  branch_name=${branch_name##refs/heads/}  # tira o prefixo refs/heads/

  git checkout -b "feature/${1:-.}"
  git add .
  eval git commit -am "\"$@\""
  git push origin "feature/${1:-.}"
  git checkout "$branch_name"   # volta pro branch de origem
}

# wf / wfs / wffs: cria branch fix/<nome>, commita tudo e faz push
alias wffs="workflow-fix-send"
alias wfs="workflow-fix-send"
alias wf="workflow-fix-send"
function workflow-fix-send() {
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"
  branch_name=${branch_name##refs/heads/}

  git checkout -b "fix/${1:-.}"
  git add .
  eval git commit -am "\"$@\""
  git push origin "fix/${1:-.}"
  git checkout "$branch_name"
}

# wh / whs / wfhs: cria branch hotfix/<nome>, commita tudo e faz push
alias wfhs="workflow-hotfix-send"
alias whs="workflow-hotfix-send"
alias wh="workflow-hotfix-send"
function workflow-hotfix-send() {
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"
  branch_name=${branch_name##refs/heads/}

  git checkout -b "hotfix/${1:-.}"
  git add .
  eval git commit -am "\"$@\""
  git push origin "hotfix/${1:-.}"
  git checkout "$branch_name"
}

# wp / wfp: faz merge da feature no dev e sobe pro master
# uso: wp <nome-da-feature>
alias workflow-publish="wfp"
alias wp="wfp"
function wfp() {
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"
  branch_name=${branch_name##refs/heads/}

  git checkout dev
  git merge "feature/${1:-.}"
  git add .
  eval git commit -am "\"$@\""
  git push origin master
  git push origin "feature/${1:-.}"
  git checkout "$branch_name"
}

# wtu / wftu: incrementa a versão da tag (ainda meio experimental)
alias wftu="workflow-tag-up"
alias wtu="workflow-tag-up"
function workflow-tag-up() {
  local release tag count
  tag=$(git describe --tags --abbrev=0)
  release=$(echo $tag | tr "." "\n")
  count=0
  for version in $release
  do
    expr $version + 1
    echo "$b + 1" | bc -l
    echo $(($version + 1))
  done
  echo "$(($count + 1))"
}
