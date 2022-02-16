#Description: Fast Calculator
export ZTTY_FEATURES="Calc:${ZTTY_FEATURES}"
_calc_usage(){
cat << USAGE
usage: calc [exp]
usage: calc bc [exp]
usage: calc bc -l [exp]
usage: calc dc [rev-polish-notation]

(default: bash built-in exp \$(( )) style )
USAGE
}


calc(){
  if [ "$1" = "-h" ] || [ "$1" = "--help" ];then
    _calc_usage
    return 0
  elif [ "$1" = "bc" ];then
    shift
    if [ "$1" = "-l" ];then
      shift
      echo "$@" | bc -l
      return $?
    fi
    echo "$@" | bc
    return $?
  elif [ "$1" = "dc" ];then
    shift
    echo "$@" | dc
  else
    echo $(( $@ ))
  fi
}



