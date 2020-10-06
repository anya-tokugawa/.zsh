##################################################
export  TASK_DIR="$HOME/.task"
export _indexFile="${TASK_DIR}/index.psv"
export _doneFile="${TASK_DIR}/done.psv"
##################################################
mkdir -p "$TASK_DIR/done.d/"
if [[ ! -e ${TASK_DIR}/.git ]]; then
  git init $TASK_DIR
fi


function _task_list_verbose(){
  cnt=0
  echo "No.|task|add date|detail"
  echo "-----|------------|---------------------|---------"
  for file in $(cut -d'|' -f1 $_indexFile )
  do
    cnt=$(echo "$cnt + 1" | bc)
    source "${TASK_DIR}/${file}.source"
    echo "$cnt|$_task_name|$_task_add_date $_task_add_time|$_task_more"
  done
}
function tadd(){
  if [[ $1 == '' ]]; then echo "plz name."; return 1; fi
  _id=$(uuidgen)
  echo "$_id|$1" >> $_indexFile
  _targetFile="${TASK_DIR}/${_id}.source"
  echo "_task_name='$1'" >> $_targetFile
  echo "_task_more='$2'" >> $_targetFile
  echo "_task_add_date='$(date +%Y-%m-%d)'" >> $_targetFile
  echo "_task_add_time='$(date +%H:%M:%S)'" >> $_targetFile
  echo "New Task to $_targetFile"
  git -C ${TASK_DIR} add $_targetFile $_indexFile
  git -C ${TASK_DIR} commit -m"ADD: $1 <$_id>"
}
function tdone(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _name=$(awk "NR==$1" $_indexFile | cut -d'|' -f2)
  git -C ${TASK_DIR} mv "${TASK_DIR}/${_id}.source" "${TASK_DIR}/done.d/${_id}.source"
  awk "NR==$1" $_indexFile >> $_doneFile
  sed -i "${1}d" $_indexFile
  echo "done $_name"
  git -C ${TASK_DIR} add $_indexFile $_doneFile
  git -C ${TASK_DIR} commit -m"DONE: $_name <$_id>"
  if [[ "$_name" == "$TASK" ]]; then TASK="" fi
}
function tdel(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _name=$(awk "NR==$1" $_indexFile | cut -d'|' -f2)
  git -C ${TASK_DIR} rm "${TASK_DIR}/${_id}.source"
  sed -i "${1}d" $_indexFile
  echo "deleted $_name <$_id>"
  git -C ${TASK_DIR} add $_indexFile
  git -C ${TASK_DIR} commit -m"DEL: $_name"
  if [[ "$_name" == "$TASK" ]]; then TASK="" fi
}
##################################################
function tget(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  source "${TASK_DIR}/${_id}.source"
  echo "Task Name: $_task_name"
  echo "Detail:    $_task_more"
  echo "Add Date:  $_task_add_date $_task_add_time"
}

function tpin(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  TASK=$(awk "NR==$1" $_indexFile | cut -d'|' -f2)
}
function tupin(){
  TASK=""
}
##################################################
function t(){
  _task_list_verbose  | column -ts'|'
}
function tsync(){
  git -C ${TASK_DIR} pull
  test $? -ne 0 && return 1
  git -C ${TASK_DIR} push
}
function tlog(){
  git -C ${TASK_DIR} log
}
