#!/bin/bash
################# LIBRARY TEMPLATE ##################
LIBNAME="$(readlink -f "$0")"; CURRENT_SHELL="$(ps -p $$ -ho cmd| head -1) "
grep -qxF "$LIBNAME" <( tr ':' '\n' <<< "$SH_READ_LIB" ) || return 1
test "$(basename "$CURRENT_SHELL")" == "bash" || return 1
export SH_READ_LIB="$LIBNAME:$SH_READ_LIB"
################# LIBRARY TEMPLATE ##################

source /etc/lsb-release
export DISTRIB_ID

_hasCommand() {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}
export -f _hasCommand

_installPrefixCmd() {

  run_as_root=""
  if [[ "$USER" != "root" ]]; then
    run_as_root="sudo"
  fi

  case "$DISTRIB_ID" in
    "Ubuntu")
      echo "${run_as_root}apt install -y"
      return 0
      ;;
    "CentOS")
      echo "${run_as_root}yum install -y"
      return 0
      ;;
    *)
      echo ""
      ;;
  esac
}
export -f _installPrefixCmd

_setConfig() {
  if [[ -f $2 ]]; then
    mv "$2" "$2.default-config"
  fi
  ln -s "$1" "$2"
}
export -f _setConfig

_yesno() {
  while :; do
    read -r p
    case "$p" in
      "y") return 0 ;;
      "n") return 1 ;;
    esac
    echo -n "(y/n): "
  done
}
export -f _yesno
