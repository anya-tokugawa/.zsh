#Description: alias alternative cmd. to basic cmd.
export ZTTY_FEATURES="ChangeAlternativeTools:${ZTTY_FEATURES}"

_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

if _hasCommand exa ; then
  alias ls="exa"
  alias la="exa -a"
  alias ll='ls --git -lbghu'
  # overwrite chpwd function
  chpwd() {
    l1=$(/bin/ls -1 | wc -l)
    l2=$(tput lines)
    test $l1 -gt $(( $l2 * 5 ))  && echo "manymanyfiles... $l1" && return 0
  }
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
