export ZTTY_PATH=$TTY
function alarm(){
  if [[ $# -lt 2 ]]
  then
    echo "usage: $0 [time] [Subject]"
    return 1
  fi
  time=$1
  subject="${@:3:($#-1)}"
  echo "echo '' ; echo ""${time}:$subject"" > $ZTTY_PATH" | at $time # 日本語不可
}
