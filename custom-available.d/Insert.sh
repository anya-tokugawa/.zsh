export ZTTY_FEATURES="Insert:${ZTTY_FEATURES}"
function insert(){
  if [[ $# == 0 || $1 == '-h' ]]
  then
    echo "usage: insert 'target_texts' 'relative_file_path'"
    return
  fi
  if [[ -f ./"$2" ]]
  then
    echo "$1" >> ./"$2" && echo "SUCCESSED!"
  else
    echo -n "Attension: file is not exist. continue? (continue as 'y'): "
    read check
    if [[ "$check" == 'y' ]]
    then
      echo "$1" >> ./"$2" && echo "SUCCESSED!"
    else
      echo "CHANSELED!"
    fi
  fi
}
