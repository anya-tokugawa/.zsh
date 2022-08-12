#!/bin/bash

_checkDepend() {
  cmdname="$1"
  pkgname="$2"
  andexit="$3"

  if _hasCommand "$cmdname"; then
    return 0

  fi

  # Not Found.
  echo "INFO: $cmdname : NG" >&2

  if [[ "$pkgname" != "" ]] || ""; then
    echo -n "> $cmdname command not found."
    echo -n "> Install Now(y/n): "
    if _yesno; then
      set +e
      eval "$INSTALL_CMD $pkgname" && return 0
      set -e
    fi
  fi

  # If Package not installed or Canceled.
  if [[ "$andexit" == 1 ]]; then
    echo "ERROR: $cmdname not installed." >&2
    exit 1
  else
    echo "WARNING: $cmdname not installed." >&2
    return 1
  fi

}
