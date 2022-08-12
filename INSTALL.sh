#!/bin/bash -u
source lib/common.bash
source lib/depend_install.bash

if [[ $# -ne 2 ]];then
  echo "usage: $0 [workspace_name] [PC_Location (Weather)]"
  exit 1
fi

INSTALL_CMD="$(_installPrefixCmd)"
current_login_shell="$(grep "^$USER" /etc/passwd | cut -d: -f7)"

if [[ "$(basename "$current_login_shell")" != "bash" ]]; then
  echo "WARNING: Current LoginShell is \"$current_login_shell\""
fi

# Dependency
_checkDepend "zsh" "zsh" 1
_checkDepend "perl" "perl" 1
_checkDepend "git" "git" 1
_checkDepend "go" "golang" 0 || echo "WARNING: uuidgenseeded can't install."
_checkDepend "autojump" "autojump" 0 || echo "WARNING: autojump extension will not able to be enabled."

if _hasCommand go; then
  if ! _hasCommand uuidgenseeded; then
    echo "Try install uuidgenseeded"
    go get github.com/syumai/uuidgenseeded
  fi
fi

echo "export ZSH_WORKSPACE=""'""$1""'" >> config
echo "export WTTR_LOCATION=""'""$2""'" >> config

set -e

curl -fsSL git.io/antigen > "$HOME/.zsh/custom-available.d/antigen.zsh"

if [[ ! -f "$HOME/.zshenv" ]]; then
  ln -s "$HOME/.zsh/.zshenv" "$HOME"
else
  echo "INFO: ~/.zshenv exist. "
fi

mkdir -p "$HOME/.zsh/custom-enable.d"
mkdir -p "$HOME/.zsh/custom.d"
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
