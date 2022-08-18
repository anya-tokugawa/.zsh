_bootmsg "Setting PROMPT"
# 20200301:
# - /etc/zshrc にPROMPT変数が定義されている。
# - ${ZDOTDIR}/.zshenv のあとに /etc/zshrcを読み込む
# - よって、.zshenv だと上書きされてしまう事象（CentOS 7)

#PROMPT="%K{black}%F{3}${HOST} %F{cyan}<"$IP_ADDRESSES"> "'${vcs_info_msg_0_}'"%F{reset}%K{reset}
#%K{0} %F{7} [%~] %#%K{reset}%F{reset} "
#
#
PREPWD=''
term_time=$(date +%s)
notifySec=4 #30 # 実行時間N秒以上の場合，処理する．
#function before_runcmd(){
#  echo "BT: "
#  term_time=$(date +%s)
#}
#trap 'before_runcmd' DEBUG
function precmd () {
      if [[ $? -eq 0 ]]
      then
        STATUS_COLOR='%F{46}'  # Green is true.
      else
        STATUS_COLOR='%F{196}' # Red is false.
      fi
      new_term_time=$(date +%s)
      last_cmds=$(fc -l -1 | head -n1 | cut -c8-)
      last_cmd=$(echo $last_cmds | cut -d' ' -f1)
      # 多く処理した場合は，通知する
      if [[ $(( $new_term_time - $term_time )) -gt $notifySec ]] && [[ -f ~/.slackrc ]]
      then
        #source ~/.slackrc
        #POST_TEXT="$last_cmd is end."
        #post_slack
        : "current disabled."
      fi
      term_time=$new_term_time

      if [[ "$last_cmd" == 'git'  ]]  ; then vcs_info; fi
      if [[ "$last_cmd" =~ 'vi.*'  ]]  ; then vcs_info; fi
      if [[ "$last_cmd" =~ '.*\>.*' ]]  ; then vcs_info; fi
      if [[ "$last_cmd" == 'cd'   ]]  ; then vcs_info; fi
      PREPWD=$(pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!')
      if [[ "$TASK" != "" ]] && [[ "${vcs_info_msg_0_}" != "" ]];then
        PROMPT="%F{013}${vcs_info_msg_0_}%F{154}* $TASK
${STATUS_COLOR}${ZSH_WORKSPACE}%F{207} > %F{reset}"
      elif [[ "$TASK" != "" ]];then
        PROMPT="%F{154}* $TASK
${STATUS_COLOR}${ZSH_WORKSPACE}%F{207} > %F{reset}"
      elif [[ "$vcs_info_msg_0_" != "" ]];then
        PROMPT="%F{013}${vcs_info_msg_0_}
${STATUS_COLOR}${ZSH_WORKSPACE}%F{207} > %F{reset}"
      else
        PROMPT="${STATUS_COLOR}${ZSH_WORKSPACE}%F{013}"'${vcs_info_msg_0_}'"${task_prompt}%F{207} > %F{reset}"
      fi

}
vcs_info
PREPWD=$(pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!')
PROMPT="${STATUS_COLOR}${ZSH_WORKSPACE}%F{013}"'${vcs_info_msg_0_}'"${task_prompt}%F{207}> %F{reset}"
RPROMPT="%F{190}"'${MEMO}'"%F{reset}"

if test "$(whoami)" == "root"
then
cat <<ATTENT
====================
HELLO ADMIN PROMPT!
====================
ATTENT
fi


	function zsh_update() {
        cd  $ZDOTDIR
        #echo "Latest: $(git log  | head -n6 | grep 'Date' | sed 's/Date:   //')"
        OLD_ZSH_CONF_VERSION=$(git log -n 1 --pretty=format:"%H")
        (git pull  > /dev/null 2>&1) && \
          ZSH_CONF_VERSION=$(git log -n 1 --pretty=format:"%H")
        if [[ "$ZSH_CONF_VERSION" != "" ]]
        then
            if [ $OLD_ZSH_CONF_VERSION != $ZSH_CONF_VERSION ]
            then
              TASK="[ZSH_UPDATED] $TASK"
            fi
        fi
    }
_bootmsg "Checking Update"
  zsh_update &! # bash の & disown 相当
_bootmsg "Define Functions [chpwd]"
  chpwd() {
    l3=$(( COLUMNS / 4 ))
    l4=$(( l3 * 2 ))
    echo "< $(pwd | perl -pe 's;^(.{'"$l3"',}?/)(.+)(/.{'"$l4"',})$;$1...$3;')"
  }
_bootmsg "Define Functions [memo]"
    function @(){
        if [ $# -eq 0 ]
        then
            # 空で指定したらリセット
            unset MEMO
            return
        else
            for text in $@
            do
                #頭に-がついてたら削除。
                if test $(echo "$text" | grep '^-' )
                then
                    local keywd=`echo  $text | sed -e 's/^-//'`
                    declare -g MEMO=`echo $MEMO | sed "s/\s$keywd/ /" | sed "s/${keywd}\s//"`
                    echo "memo buffer removed: $keywd"
                else
                    local exist_flag=0
                    for i in $(echo $MEMO | xargs)
                    do
                        test "$i" = "$text" && exist_flag=1 && break
                    done
                    if test $exist_flag -eq 0
                    then
                        declare -g MEMO="${MEMO} ${text}"
                        echo "memo buffer added: ${text}"
                    else
                        echo "memo buffer exist: ${text}"
                    fi
                fi
            done
        fi
    }
_bootmsg "Define Functions [zshaddhistory]"
zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}
  test $(echo ${line} |grep -o '\n' |wc -l)  -lt 10 || echo '*no Insert History'
}

_bootmsg "Define Functions [memo_write]"
function memo_write(){
    if test "$MEMO" = ""
    then
        # 変数が空ならば、リセットする。
        echo '' > ${ZDOTDIR}/MEMO.txt
    else
        for i in $(echo $MEMO | xargs)
        do
            local exist_flag=0
            # 存在チェック
            for x in $(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)
            do
                if test "$i" = "$x"
                then
                    exist_flag=1
                fi
            done
            if test $exist_flag -eq 0
            then #存在しないならば
                 echo "memo: add - $i"
                 echo $i >> ${ZDOTDIR}/MEMO.txt
            else
                echo "memo: exist - $i"
            fi
        done
        # ファイルにあるが、変数に存在しない文字列を削除
        local MEMO_LIST=`echo $MEMO | tr ' ' '\n'`
        for i in $(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)
        do
            # ファイルのMEMO_LISTをGrep(完全一致）して、完全一致しなければ（Revirse) Grepで行削除
            if test ! "$( echo $MEMO_LIST | grep -x $i)"
            then
                grep -v "^${i}" ${ZDOTDIR}/MEMO.txt | tee ${ZDOTDIR}/MEMO.txt > /dev/null
                test "$?" -eq 0  && echo "memo: removed - $i"
            fi
        done
    fi
}
alias @write='memo_write'

_bootmsg "Define Functions [title]"
function title() { echo -e "\033]0;${1:?please specify a title}\007" ; }
_bootmsg "Define Functions [@reload]"
function @reload(){
  export  MEMO=$(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)
}
_bootmsg "Define Functions [wttr]"
function wttr(){
  if [[ $1 = "" ]]
  then
    _wttr=$WTTR_LOCATION
  else
    _wttr=$1
  fi
  curl https://ja.wttr.in/${_wttr}?format="%l:+%c\n------\nReal:+%t\nFeel:+%f\nWind:+%w\nSunRise:+%S\nSun-Set:+%s\n"
}

##############################
## EXIT
_bootmsg "Define exit function"
_exit_function(){
  memo_write
########################################
# check close process

_wait_proc(){
  while :
  do
    if ps "$1" 2>&1 >/dev/null ;then
      continue
    fi
    break
  done
}

# Auto Close Terminal

if [ -v ZTERM_A3C_PID ];then
  kill -15 "$ZTERM_A3C_PID"
  _wait_proc "$ZTERM_A3C_PID"
  unset ZTERM_A3C_PID
fi
  # PPIDが`init`でRunningしているWSLの場合は、Exit 0で切らせる。
  test "$(ps -o comm "$PPID" | tail -n1)" = "init" && return 0
}


trap "_exit_function" EXIT INT

_bootmsg "Loading Extensions"
for i in $(/bin/ls -1 "${ZDOTDIR}/custom-enable.d")
do
    _bootmsg "Loading Extensions [${i}]"
    source "${ZDOTDIR}/custom-enable.d/${i}"
done
_bootmsg "Loading Custom Extensions"
for i in $(/bin/ls -1 "${ZDOTDIR}/custom.d")
do
    _bootmsg "Loading Custom Extensions [${i}]"
    source "${ZDOTDIR}/custom.d/${i}"
done

_bootmsg "Loading cache MEMO"
declare -g  MEMO=$(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)

# Trap exit to run .zlogout
#source $ZDOTDIR/logout.sh
alias exit="_exit_functiont; exit" # run _exit_function before exit


TRAPEXIT() {
      memo_write
      source "${HOME}/.zsh/.zlogout"
}


rm $ZLOCKFILE

clear
for i in $(/bin/ls -1 "${ZDOTDIR}/display.d")
do
    source "${ZDOTDIR}/display.d/${i}"
done
