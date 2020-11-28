##################################################
export  TASK_DIR="$HOME/.task"
export _indexFile="${TASK_DIR}/index.psv"
export _doneFile="${TASK_DIR}/done.psv"
##################################################
mkdir -p "$TASK_DIR/done.d/"
mkdir -p "$TASK_DIR/note.d/"

if [[ ! -e ${TASK_DIR}/.git ]]
then
  git init $TASK_DIR
fi

function _task_list() {
  cnt=0

  case "$1" in
    "verbose")
      echo "No.|note|task|add date|detail|tags|uuid"
      echo "-----|----|----------------------|---------------------|---------|--------|----------------------" ;;
    "short")
      echo "No.|task"
      echo "---|----" ;;
    *)
      echo "No.|note|task|add date|detail|tags"
      echo "-----|----|----------------------|---------------------|---------|--------" ;;
  esac
  suffix='\033[0;37m'

  for file in $(cut -d'|' -f1 $_indexFile )
  do
    prefix=""
    cnt=$(echo "$cnt + 1" | bc)
    source "${TASK_DIR}/${file}.source"
    note=""
    if [[ -f "${TASK_DIR}/note.d/${file}.md" ]]
      then note="NOTE"
    fi
    for tag in $(echo $_task_tags | xargs)
    do
      test "$tag" = "1" && prefix='\033[0;31m' && continue
      test "$tag" = "2" && prefix='\033[0;33m' && continue
      test "$tag" = "3" && prefix='\033[0;36m' && continue
      test "$tag" = "0" && prefix='\033[0;32m' && continue
    done

    case "$1" in
      "verbose") echo -e "$prefix $cnt | $note | $_task_name| $_task_add_date $_task_add_time| $_task_more| $_task_tags| $file $suffix" ;;
      "short") echo -e "$prefix $cnt | $_task_name" ;;
      *) echo -e  "$prefix $cnt| $note | $_task_name| $_task_add_date $_task_add_time| $_task_more| $_task_tags | $suffix" ;;
    esac
  done
}
function _task_list_json() {
  cnt=0
  echo -ne "{\n"
  for file in $(cut -d'|' -f1 $_indexFile )
  do
    cnt=$(echo "$cnt + 1" | bc)
    if [[ $cnt -ne 1 ]]
    then
      echo -ne ",\n"
    fi
    source "${TASK_DIR}/${file}.source"
    fixedTags=$(
      echo $_task_tags | xargs \
        | sed -e 's;^\ *;;g' \
        | sed -e 's;\ *$;;g' \
        | sed -e 's;\ ;", ";g' \
        | sed -e 's;^;";g' \
        | sed -e 's;$;";g'
      )
  if [[ "$fixedTags" != '""' ]]
    then tagsText="[$fixedTags]"
    else tagsText='null'
  fi
  echo -ne "  \"${file}\": {
    \"name\": \"$_task_name\",
    \"more\": \"$_task_more\",
    \"date\": \"$_task_add_date\",
    \"time\": \"$_task_add_time\",
    \"tags\": $tagsText,
    \"line\": $cnt
  }"
  done
  echo -ne "\n}\n"
}

function _task_add(){
  if [[ $1 == '' ]]; then echo "plz name."; return 1; fi
  _id=$(uuidgen)
  echo "$_id|$1" >> $_indexFile
  _targetFile="${TASK_DIR}/${_id}.source"
  fix_name="$(echo $1 | sed -e "s;\';;g" )"
  fix_more="$(echo $2 | sed -e "s;\';;g")"
  echo "_task_name=\"$fix_name\"" >> $_targetFile
  echo "_task_more=\"$fix_more\"" >> $_targetFile
  echo "_task_add_date='$(date +%Y-%m-%d)'" >> $_targetFile
  echo "_task_add_time='$(date +%H:%M:%S)'" >> $_targetFile
  echo "_task_tags=" >> $_targetFile
  echo "New Task to $_targetFile"
  git -C ${TASK_DIR} add $_targetFile $_indexFile
  git -C ${TASK_DIR} commit -m"ADD: $1 <$_id>"
}


function _task_done(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _name=$(awk "NR==$1" $_indexFile | cut -d'|' -f2)
  git -C ${TASK_DIR} mv "${TASK_DIR}/${_id}.source" "${TASK_DIR}/done.d/${_id}.source"
  awk "NR==$1" $_indexFile >> $_doneFile
  sed -i "${1}d" $_indexFile
  echo "done $_name"
  git -C ${TASK_DIR} add $_indexFile $_doneFile
  git -C ${TASK_DIR} commit -m"DONE: $_name <$_id>"
  if [[ "$_name" == "$TASK" ]]
  then
    TASK=""
  fi
}

function _task_delete(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _name=$(awk "NR==$1" $_indexFile | cut -d'|' -f2)
  git -C ${TASK_DIR} rm "${TASK_DIR}/${_id}.source"
  sed -i "${1}d" $_indexFile
  echo "deleted $_name <$_id>"
  git -C ${TASK_DIR} add $_indexFile
  git -C ${TASK_DIR} commit -m"DEL: $_name"
  if [[ "$_name" == "$TASK" ]]
  then
      TASK=""
  fi
}
##################################################
function _task_get(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  source "${TASK_DIR}/${_id}.source"
  echo "Task: $_task_name"
  echo "Detail:    $_task_more"
  echo "Add Date:  $_task_add_date $_task_add_time"
  echo "TAGS: $_task_tags"
}

function _task_read(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _rf=$(mktemp)
  source "${TASK_DIR}/${_id}.source"
echo "
Task:   $_task_name
Detail: $_task_more
Date:   $_task_add_date $_task_add_time
TAGS:   $_task_tags
-----------------------------------------
" >> $_rf
  cat "${TASK_DIR}/note.d/${_id}.md" >> $_rf
  less $_rf

}

function _task_edit(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _temp=$(mktemp)
  _targetFile="${TASK_DIR}/${_id}.source"
  cp "$_targetFile" "$_temp" && vi "$_targetFile"
  if [[ $(diff -q "$_targetFile" "$_temp") != "" ]]
  then
    git -C "${TASK_DIR}" add $_targetFile && git -C "${TASK_DIR}" commit -m"MODIFY: $_id"
  else
    echo "Not Modified."
  fi
}

function _task_tags(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi

  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _targetFile="${TASK_DIR}/${_id}.source"
  source $_targetFile
  if [[ $2 == '' ]]
  then
    echo "$_task_tags"
    return 0
  fi

  for tag in ${@:2}
  do
    [ "$_task_tags" != '' ] && _task_tags=" $_task_tags"
    tag_name="$(echo $tag | cut -c 2- )"
    sedPtn="s;\ $tag_name;;g"
    tag_prefix=$(echo $tag | cut -c 1 )
    ok=0
    [ "$tag_prefix" = "+" ] && _task_tags="$tag_name$_task_tags" && ok=1
    [ "$tag_prefix" = "-" ] && _task_tags="$(echo $_task_tags | sed -e "$sedPtn" )" && ok=1
    [ $ok -eq 0 ] && echo "task tags process terminated: plz prefix '+' or '-' " > /dev/stderr && return 1
  done

  echo -n '' > $_targetFile
  echo "_task_name=\"$_task_name\"" >> $_targetFile
  echo "_task_more=\"$_task_more\"" >> $_targetFile
  echo "_task_add_date=\"$_task_add_date\"" >> $_targetFile
  echo "_task_add_time=\"$_task_add_time\"" >> $_targetFile
  echo "_task_tags=\"$_task_tags\"" >> $_targetFile
  git -C ${TASK_DIR} add $_targetFile
  git -C ${TASK_DIR} commit -m"Tags Modified: ${@:2}"
}

function _task_pin(){
  if [[ $1 == '' ]]
  then
    TASK=""
  else
    TASK=$(awk "NR==$1" $_indexFile | cut -d'|' -f2)
  fi
}
function _task_note(){
  if [[ $1 == '' ]]; then echo "plz id."; return 1; fi
  _id=$(awk "NR==$1" $_indexFile | cut -d'|' -f1)
  _temp=$(mktemp)
  _targetFile="${TASK_DIR}/note.d/${_id}.md"
  if [[ -e $_targetFile ]]
  then
    cp "$_targetFile" "$_temp"
    vi "$_targetFile"
    if [[ $(diff -q "$_targetFile" "$_temp") != "" ]]
    then
      git -C "${TASK_DIR}" add $_targetFile && git -C "${TASK_DIR}" commit -m"MODIFY: $_id"
    else
      echo "Not Modified."
    fi
  else
    vi "$_targetFile"
    git -C "${TASK_DIR}" add $_targetFile && git -C "${TASK_DIR}" commit -m"CREATE: $_id"
  fi
}

##################################
function _task_show(){
  indexLength=$(wc -l $_indexFile | awk '{print $1}')
  if [[ $indexLength -gt $(tput lines) ]]
  then
    outopts="less -SR"
  else
    outopts="tee"
  fi

  if [ "$1" = "raw" ]
  then
    _task_list $@
  else
    if [ $indexLength -gt $(tput lines) ]
    then
      outopts="less -SR"
    elif [ $( _task_list $@ | column -ts'|' | awk '{ print length }' | sort | tail -n1) -gt  $(tput cols) ] && [ $( _task_list short | column -ts'|' | awk '{ print length }' | sort | tail -n1) -lt  $(tput cols) ] && [ "$1" == "" ]
      then
        _task_list short | column -ts'|'
        return
    else
      outopts="tee"
    fi
    if [ "$1" = "grep" ]
    then
      _task_list $@ | column -ts'|' | head -n1
      _task_list $@ | column -ts'|' | grep ${@:2}
      echo -e "TAG: \033[0;31m[1] Important \033[0;33m[2] Warning \033[0;36m[3] Pending \033[0;32m[0] No-Problem"
    else
      _task_list $@ | column -ts'|'
      echo -e "TAG: \033[0;31m[1] Important \033[0;33m[2] Warning \033[0;36m[3] Pending \033[0;32m[0] No-Problem"
    fi | eval "$outopts"
  fi
}
function _task_sync(){
  echo "sync .task git-repo."
  git -C "${TASK_DIR}" pull
  test $? -ne 0 && return 1
  git -C "${TASK_DIR}" push
}

function _task_log(){
  git -C ${TASK_DIR} log
}
function  _task_help(){
/bin/cat << HELP_TEXT
usage: t [COMMAND] [SUFFIX]

COMMAND:
 add  TITLE [detail]
 [done | read | edit | note | del | get | pin | json ] ID
 sync
 log
 tags [id] [+ADD_TAG] [-REMOVE_TAG]
 grep [grep_some_opt]
 help
 lhelp
HELP_TEXT
}
function _task_long_help(){
/bin/cat << HELP_LONG_TEXT
usage: t [COMMAND] [SUFFIX]

COMMAND:
  add  TITLE [DETAIL] ... Add Task
  read ID .. read Task and Note by less
  edit ID .. edit Task by vi
  note ID .. edit Note by vi
  done ID .. done Task
  del  ID .. delete Task
  get  ID .. get Task Abst.
  json ID .. Output Tasks to JSON
  pin  ID .. Pinned ZSH_TERM
  sync ID .. Sync by git
  log  ID .. Check log by git
  tags ID [+ADD_TAG] [-REMOVE_TAG] .. add/remove Tags
  grep GREP_SOME_OPTS .. search Task
  help .. Short-help
  lhelp .. this.

HELP_LONG_TEXT
}

function t(){
  case "$1" in
    "add")  _task_add ${@:2} ;;
    "done") _task_done $2 ;;
    "edit") _task_edit $2 ;;
    "read") _task_read $2 ;;
    "note") _task_note $2 ;;
    "del")  _task_delete $2 ;;
    "get")  _task_get $2 ;;
    "json") _task_list_json $1 ;;
    "pin")  _task_pin $2 ;;
    "sync") _task_sync ;;
    "log")  _task_log  ;;
    "tags") _task_tags ${@:2} ;;
    "help") _task_help ;;
    "lhelp") _task_long_help ;;
    *)      _task_show $@;;
  esac
}
