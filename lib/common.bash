#!/bin/bash
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
