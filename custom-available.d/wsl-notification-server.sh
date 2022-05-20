#Description: Enable WSL Notify to Windows Toast. and SSH Alias
export ZTTY_FEATURES="WslNotificationServer:${ZTTY_FEATURES}"

export WSL_NOTIF_PORT="47123"

if [[ -v WSL_DISTRO_NAME ]];then
_waitWslNotification() {
  source /etc/lsb-release
  WSL_NOTIF_LOGO_PATH=" "
  case "$DISTRIB_ID" in
    "Ubuntu") logo="-AppLogo $(wslpath -w "$HOME/.zsh/assets/logos/ubuntu.png")" ;;
    *) logo="-AppLogo $(wslpath -w "$HOME/.zsh/assets/logos/linux.png")" ;;
  esac
  while true; do
    local p=$WSL_NOTIF_PORT
    while lsof -i:"$p" >&/dev/null; do
      sleep "$((RANDOM % 30))"
    done
    recv="$(nc -w1 -lvp"$p" -s"127.0.0.1")"
    set -x
    [[ "$recv" != "" ]] && powershell.exe "New-BurntToastNotification $logo $recv"
    set +x
  done
}
_waitWslNotification &!
fi

wslnotify() {
  local text=""
  local sound=""
  while [[ $1 ]]; do
    case "$(echo "$1" | cut -c1-2)" in
      "-t")
        text="$2"
        shift
        shift
        ;;
      "-a")
        v="$(echo "$1" | cut -c3-)"
        if (echo "$v" | grep -q '[0-9]\+'); then
          if [[ "$v" == "1" ]]; then
            sound="-Sound Alarm"
          else

            sound="-Sound Alarm$v"
          fi
          shift
        elif (echo "$2" | grep -q '[0-9]\+'); then
          sound="-Sound Alarm${2}"
          shift
          shift
        else
          sound="-Sound Alarm"
          shift
        fi
        ;;
      "-c")
        if (echo "$2" | grep -q '[0-9]\+'); then
          sound="-Sound Call${2}"
          shift
          shift
        else
          sound="-Sound Call"
          shift
        fi
        ;;
      *)
        text="$text $1"
        shift
        ;;
    esac
  done
  echo "$sound -Text \"$text\"" | nc -w1 127.0.0.1 "$WSL_NOTIF_PORT"
}

alias ssh="ssh -R ${WSL_NOTIF_PORT}:localhost:${WSL_NOTIF_PORT}"

