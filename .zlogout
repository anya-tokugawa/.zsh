########################################
# WindowsTerminal WSL Integration
parentProcName="$(ps axo pid,comm | grep " $PPID " | awk '{print $2}')"

if [[ -n "$WSL_DISTRO_NAME" ]] && [[ "$parentProcName" == "init" ]];then
  exit 0 # Normally exit.
fi

#### History Write
if ( tr ':' '\n' <<< "$ZTTY_FEATURES" | grep -qxF "RotateZshHistory");then
  _writeHistoryWithDate 2> /dev/null
fi
