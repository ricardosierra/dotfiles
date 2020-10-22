
# Work Workflow shortcuts

# Add all files by default
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