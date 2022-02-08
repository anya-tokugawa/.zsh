#!/bin/bash -u

_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

_setConfig(){
  if [[ -f $2 ]]
  then
    mv "$2" "$2.default-config"
  fi
  ln -s "$1" "$2"
}

if ! _hasCommand zsh ;then
  echo "zsh command not found. exit..."
  exit 1
fi

echo -n "Input current workspace name -> "
read -r ws_name
echo "export ZSH_WORKSPACE=""'""$ws_name""'" >> config

echo -n "Input Wttr.in Location -> "
read -r wttr
echo "export WTTR_LOCATION=""'""$wttr""'" >> config

# Dependency

_hasCommand zsh  || echo "WARNING: zsh  is not found!"
_hasCommand perl || echo "WARNING: perl is not found!"
_hasCommand git  || echo "WARNING: git  is not found!"
_hasCommand go && go get github.com/syumai/uuidgenseeded \
              || echo -e "WARNING: go   is not found!\n note: 'uuidgenseeded' does not install." \

set -e

curl -fsSL git.io/antigen > "$HOME/.zsh/custom-available.d/antigen.zsh"

if [[ ! -f "$HOME/.zshenv" ]];then
  ln -s "$HOME/.zsh/.zshenv" "$HOME"
else
  echo "WARNING: ~/.zshenv exist. "
fi
mkdir -p "$HOME/.zsh/custom-enable.d"
mkdir -p "$HOME/.zsh/custom.d"
mkdir -p "$HOME/.zsh/TMUX_SESSIONS"
touch    "$HOME/.zsh/MEMO.txt"
mkdir -p "$HOME/.local/packages"


# linked dotFiles
dotBase="$HOME/.zsh/src.dotfiles"
_setConfig  "${dotBase}/bash_run_cmd.sh" "$HOME/.bashrc" # .bashrc
_setConfig  "${dotBase}/htop_run_cmd.config" "$HOME/.config/htop/htoprc"
_setConfig  "${dotBase}/tmux.conf" "$HOME/.tmux.conf"




cat <<EOF
+----------------------+
| SETUP SUCCESSFUL !!! |
+----------------------+
EOF

