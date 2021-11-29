export ZTTY_FEATURES="GitLongCmd:${ZTTY_FEATURES}"
function git-remove-all-history(){
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $@" --prune-empty --tag-name-filter cat -- --all
}
function git-oneline(){
  if [[ $# -ne 2 ]]
  then
    echo "usage: git-onelne [COMMIT_MESG] [FILE]"
    echo "proc: add file and commit with commit-mesg"
    return 1
  fi
  git add $2
  git commit -m"$1"

}
