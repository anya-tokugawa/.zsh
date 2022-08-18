#Description: alias alternative cmd. to basic cmd.
export ZTTY_FEATURES="ChangeAlternativeTools:${ZTTY_FEATURES}"

_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

if _hasCommand exa ; then
  alias ls="exa --icons --git"
  alias la="exa -a --icons --git"
  alias ll='ls --git -lbghu --icons'
  _ls(){
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
      echo "${PWD}: [$(git rev-parse --abbrev-ref HEAD)]"
        git status -sb
        echo ----------
    else
        echo "${PWD}:"
    fi
    exa --git --icons --group-directories-first -F --sort modified .
    zle reset-prompt
  }
  # overwrite chpwd function
fi

while read line
do
  orgCmd=$(echo $line | cut -d, -f1)
  altCmd=$(echo $line | cut -d, -f2)
  if _hasCommand $altCmd
  then
    eval "alias $orgCmd='$altCmd'"
  fi
done << EOF
cat,bat
apt,apt-fast
EOF
# find,fd
