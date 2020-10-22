
# Work Workflow shortcuts

# Add all files by default
alias workflow-send="jf"
alias wfs="jf"
alias ws="jf"
function jf() { 
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"     # detached HEAD
  branch_name=${branch_name##refs/heads/}

  git checkout -b "feature/${1:-.}"
  git add .
  eval git commit -am "\"$@\""
  git push origin "feature/${1:-.}"
  git checkout "$branch_name"
} 

# Add all files by default
alias workflow-publish="wfp"
alias wp="wfp"
function wfp() { 
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"     # detached HEAD
  branch_name=${branch_name##refs/heads/}

  git checkout dev
  git merge "feature/${1:-.}"
  git add .
  eval git commit -am "\"$@\""
  git push origin master
  git push origin "feature/${1:-.}"
  git checkout "$branch_name"
} 

# Add all files by default
alias wftu="workflow-tag-up"
alias wtu="workflow-tag-up"
function workflow-tag-up() { 
  local release tag count
  tag=$(git describe --tags --abbrev=0)
  release=$(echo $tag | tr "." "\n")
  count=0
  for version in $release
  do
    # count=1+$count
    expr $version + 1
    echo "$b + 1" | bc -l
    echo $(($version + 1))
  done
  echo "$(($count + 1))"
} 