########################################
# check close process

_wait_proc(){
  while :
  do
    if ps "$1" 2>&1 >/dev/null ;then
      continue
    fi
    break
  done
}

# Auto Close Terminal

if [ -v ZTERM_A3C_PID ];then
  kill -15 "$ZTERM_A3C_PID"
  _wait_proc "$ZTERM_A3C_PID"
  unset ZTERM_A3C_PID
fi
########################################
# WindowsTerminal WSL Integration
parentProcName="$(ps axo pid,comm | grep " $PPID " | awk '{print $2}')"
echo "$parentProcName"

if [[ -n "$WSL_DISTRO_NAME" ]] && [[ "$parentProcName" == "init" ]];then
  exit 0 # Normally exit.
fi

#### History Write
if ( tr ':' '\n' <<< "$ZTTY_FEATURES" | grep -qxF "RotateZshHistory");then
  _writeHistoryWithDate
fi
