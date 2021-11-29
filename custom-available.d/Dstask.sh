export ZTTY_FEATURES="Dstask:${ZTTY_FEATURES}"

d() {
  if [[ "$1" ==  "" ]]
  then
    dstask show-unorganised
    echo "Attension: Default 'dstask' run as 'd all'"
    return 0
  fi
  if [[ "$1" ==  "all" ]]
  then
    dstask
    return 0
  fi
  if [[ "$1" ==  "sh" || "$1" == "show" ]]
  then
    case "$2" in
      "pr" | "pro" | "projects" )
        dstask show-projects ;;
      "ta" | "tags" )
        dstask show-tags ;;
      "ac" | "now" )
        dstask show-active ;;
      "pa" | "stopped" )
        dstask show-paused ;;
      "op")
        dstask show-open ;;
      "re" | "resolved" )
        dstask show-resolved ;;
      "un" | "unorganised" | "untagged" | "unproj" | "unprojects" )
        dstask show-unorganised ;;
      * )
        echo "dstask.sh: $2 - no_opt defined"
    esac
  else
    dstask "$@"
  fi
}
