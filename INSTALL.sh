#!/bin/bash -eu

_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

echo -n "Input current workspace name -> "
read ws_name

echo -n "Input Wttr.in Location -> "
read wttr
echo "export WTTR_LOCATION=""'""$wttr""'" >> config

# Dependency

_hasCommand zsh  || echo "WARNING: zsh  is not found!"
_hasCommand perl || echo "WARNING: perl is not found!"
_hasCommand git  || echo "WARNING: git  is not found!"

curl -fsSL git.io/antigen > $HOME/.zsh/custom-available.d/antigen.zsh

ln -s $HOME/.zsh/.zshenv $HOME/

mkdir -p $HOME/.zsh/custom-enable.d/
mkdir -p $HOME/.zsh/custom.d/

cat <<EOF
+----------------------+
| SETUP SUCCESSFUL !!! |
+----------------------+
EOF

