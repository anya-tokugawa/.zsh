
_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

if _hasCommand exa ; then
  alias ls="exa"
  alias la="exa -a"
  alias ll='ls --git -lbghu'
  # overwrite chpwd function
  function chpwd() { test $(/bin/ls -1 | wc -l) -gt 10 && exa || exa -lbghu --git }
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
find,fd
cat,bat
apt,apt-fast
EOF
