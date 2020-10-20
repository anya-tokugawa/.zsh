palFileName=$(grep '^file' ~/.pal/pal.conf | cut -d' ' -f2)
palFilePath="$HOME/.pal/$palFileName"
palPath=$(which pal)

function pal-add(){
  # YYYYMMDD OTHER
  #echo $@
  echo "$@" >> "$palFilePath"
}
function pal-del(){
  sed -i "s;$1;;g" $palFilePath
}
function pal(){
  case "$1" in
    "add") pal-add ${@:2} ;;
    *) eval $palPath -c 0 -r 5 $@  ;;
  esac
}


#alias pal='pal -c 0 -d today' # not show calendar. only today schedule.


