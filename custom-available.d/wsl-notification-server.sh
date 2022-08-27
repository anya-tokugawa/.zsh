#Description: Enable WSL Notify to Windows Toast. and SSH Alias
export ZTTY_FEATURES="WslNotificationServer:${ZTTY_FEATURES}"

export WSL_NOTIF_PORT="47123"

if [[ -v WSL_DISTRO_NAME ]]; then
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
      recv="$(nc -w1 -lvp"$p" -s"127.0.0.1" )" > /dev/null 2>&1
      [[ "$recv" != "" ]] && powershell.exe "New-BurntToastNotification $logo $recv"
    done

  }
if ! (lsof -i:"$WSL_NOTIF_PORT" > /dev/null 2>&1);then
_bootmsg "run _waitWslNotification"
_waitWslNotification &! #>&/dev/null
fi
fi
_bootmsg "Define wslnotify utils"
_wslnotify_help(){
cat << USAGE
Usage: wslnotify [-a AlarmNumber(1-10) | -c CallNumber(1-10)] [-t text]

Options:
 -a | --alarm [number]: ring alarm
 -c | --call  [number]: ring alarm
 -t | --text  [text]: notify text
 -v | --verbose: verbose mode
 -h | --help: help text(this)
USAGE
}

wslnotify() {
  text=""
  sound=""
  verbose=1
  OPTS=$(getopt -o hva:c:t: -l help,verbose,alarm:,call:,text: -- "$@")
  p=$?
  if  ! $(return $p) || [[ $# -eq 0 ]]; then
    _wslnotify_help
    return 1
  fi
  eval set -- "$OPTS"
  while true; do
    case $1 in
      -h | --help)
        _wslnotify_help
        return 0
        ;;
      -v | --verbose)
        verbose=0
        textmode=false
        shift
      ;;

      -a | --alarm)
        if [[ $2 -lt 1 ]] || [[ $2 -gt 10 ]];then
          echo "Error: Invalid Alarm Number: $2"
          return 1
        fi
        if [[ $2 -lt 1 ]] || [[ $2 -gt 10 ]];then
          echo "Error: Invalid Call Number: $2"
          return 1
        fi
        sound="-Sound Alarm$2"
        [[ $2 -eq 1 ]] && sound="-Sound Alarm"
        shift 2
        ;;
      -c | --call)
        sound="-Sound Call$2"
        [[ $2 -eq 1 ]] && sound="-Sound Call"
        shift 2
        ;;
      -t | --text)
        text="-Text $2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Error: getopts error." >&2
        return 1
        ;;
    esac
  done
  if $(return $verbose);then
    echo "VERBOSE: Send to \"$sound -Text \"$text\"\""
  fi
  echo "$sound $text" | nc -w1 127.0.0.1 "$WSL_NOTIF_PORT"
}
export SSH_OPTS='-R ${WSL_NOTIF_PORT}:localhost:${WSL_NOTIF_PORT}'"$SSH_OPTS"
alias ssh='ssh -R ${SSH_OPTS}'
