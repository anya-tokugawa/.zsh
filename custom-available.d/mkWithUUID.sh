# Require: https://github.com/syumai/uuidgenseeded

function mkuuidfile() {
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[  "$1" == "--help" ]]
  then
    echo "usage: $0 [files...]"
    return 1
  fi
  for p in $@
  do
    d="$(dirname "$p")"
    b="$(basename "$p")"
    u="$(uuidgenseeded -lower $b | cut -d'-' -f1 )"
    touch "${d}/${u}-${b}"
  done
}
########################################################
# for move
function convToUuid() {
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[  "$1" == "--help" ]]
  then
    echo "usage: $0 [files|dir ...]"
    return 1
  fi
  for p in $@
  do
    d="$(dirname "$p")"
    b="$(basename "$p")"
    u="$(uuidgenseeded  -lower $b | cut -d'-' -f1 )"
    mv "$p" "${d}/${u}-${b}"
  done
}

function mkuuiddir() {
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[  "$1" == "--help" ]]
  then
    echo "usage: $0 [dir...]"
    return 1
  fi
  for p in $@
  do
    d="$(dirname "$p")"
    b="$(basename "$p")"
    u="$(uuidgenseeded  -lower "$b" | cut -d'-' -f1 )"
    mkdir "${d}/${u}-${b}"
  done
}
