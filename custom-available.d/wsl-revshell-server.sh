#Description: Enable WSL Notify to Windows Toast. and SSH Alias
export ZTTY_FEATURES="WslRevshellServer:${ZTTY_FEATURES}"

export WSL_REVSH_PORT="47124"

if [[ -v WSL_DISTRO_NAME ]]; then
  _waitWslRevshell() {
    source /etc/lsb-release
    while true; do
      local p=$WSL_REVSH_PORT
      while lsof -i:"$p" >&/dev/null; do
        sleep "$((RANDOM % 30))"
      done
      recv="$(nc -w1 -lvp"$p" -s"127.0.0.1")"
      set -x
      [[ "$recv" != "" ]] && powershell.exe "$recv"
      set +x
    done
  }
if ! (lsof -i:"$WSL_REVSH_PORT" > /dev/null 2>&1);then
_waitWslRevshell &! >&/dev/null
fi
fi

_slnotify_help(){
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

wslrevshell() {
  text=""
  verbose=1
  OPTS=$(getopt -o hvc: -l help,verbose,,cmd:, -- "$@")
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

      -c | --cmd)
        text="$2"
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
    echo "VERBOSE: Send to cmdt \"$text\"\""
  fi
  echo "$text" | nc -w1 127.0.0.1 "$WSL_REVSH_PORT"
}
export SSH_OPTS="-R ${WSL_REVSH_PORT}:localhost:${WSL_REVSH_PORT} $SSH_OPTS"
alias ssh="ssh ${SSH_OPTS}"
