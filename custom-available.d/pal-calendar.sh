palFileName=$(grep '^file' ~/.pal/pal.conf | cut -d' ' -f2)
palFilePath="$HOME/.pal/$palFileName"
[ $(which pal | wc -l) -eq 1 ] && palPath=$(which pal)

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
    "-h"|"--help")
      eval "$palPath -h" | head -n-2
      echo ""
      echo "External SubCOMMAND"
      echo "  add YYYYMMDD SCHEDULE - add Calendar."
      echo ""
      echo "Type \"man pal\" for more information." ;;
    *) eval "$palPath -c 0 -r 5 $@"  ;;
  esac
}


#alias pal='pal -c 0 -d today' # not show calendar. only today schedule.


