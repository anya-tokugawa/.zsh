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
