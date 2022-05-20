#!/bin/bash -u
source /etc/lsb-release
INSTALL_CMD=":"
case "$DISTRIB_ID" in
  "Ubuntu")
    echo "Type: Ubuntu(APT)"
    INSTALL_CMD="sudo apt install"
    ;;
esac

_hasCommand() {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

_setConfig() {
  if [[ -f $2 ]]; then
    mv "$2" "$2.default-config"
  fi
  ln -s "$1" "$2"
}
_yesno() {
  while :; do
    read p
    case "$p" in
      "y") return 0 ;;
      "n") return 1 ;;
    esac
    echo -n "(y/n): "
  done
}

if ! _hasCommand zsh; then
  echo -n "zsh command not found. Install Now(y/n): "
  if _yesno; then
    eval "$INSTALL_CMD zsh"
  else
    echo exiting.
    exit 1
  fi
fi

echo -n "Input current workspace name -> "
read -r ws_name
echo "export ZSH_WORKSPACE=""'""$ws_name""'" >> config

echo -n "Input Wttr.in Location -> "
read -r wttr
echo "export WTTR_LOCATION=""'""$wttr""'" >> config

# Dependency

_hasCommand zsh || echo "WARNING: zsh  is not found!"
_hasCommand perl || echo "WARNING: perl is not found!"
_hasCommand git || echo "WARNING: git  is not found!"
_hasCommand go && go get github.com/syumai/uuidgenseeded ||
  echo -e "WARNING: go   is not found!\n note: 'uuidgenseeded' does not install."

set -e

curl -fsSL git.io/antigen > "$HOME/.zsh/custom-available.d/antigen.zsh"

if [[ ! -f "$HOME/.zshenv" ]]; then
  ln -s "$HOME/.zsh/.zshenv" "$HOME"
else
  echo "WARNING: ~/.zshenv exist. "
fi

mkdir -p "$HOME/.zsh/custom-enable.d"
mkdir -p "$HOME/.zsh/custom.d"
mkdir -p "$HOME/.zsh/TMUX_SESSIONS"
touch "$HOME/.zsh/MEMO.txt"
mkdir -p "$HOME/.local/packages"

# linked dotFiles
dotBase="$HOME/.zsh/src.dotfiles"
_setConfig "${dotBase}/bash_run_cmd.sh" "$HOME/.bashrc" # .bashrc
_setConfig "${dotBase}/htop_run_cmd.config" "$HOME/.config/htop/htoprc"
_setConfig "${dotBase}/tmux.conf" "$HOME/.tmux.conf"

if [[ -v WSL_DISTRO_NAME ]]; then
  # If Wsl
  echo "[WSL] Windows BurnToast Module Install."
  # TODO: If Powershell v7, Able to use '&&' and '||'
  gsudo.exe powershell.exe 'Install-Module -Name BurntToast;Set-ExecutionPolicy -ExecutionPolicy ByPass;Import-Module BurntToast'
  # untest: yes Y | gsudo.exe powershell.exe 'Install-Module -Name BurntToast'
  echo "[WSL] Test Toast"
  powershell.exe 'New-BurntToastNotification -Text Successful!'
fi

cat << EOF
+----------------------+
| SETUP SUCCESSFUL !!! |
+----------------------+
EOF
