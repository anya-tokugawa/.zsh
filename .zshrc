source $ZDOTDIR/config
PREPWD=''
term_time=$(date +%s)
#typeset -g -a arr1
##################################
## chpwd: change workdir.
function chpwd() {
  test $(/bin/ls -1 | wc -l) -gt 10 && ls || ll
}
## precmd: before show prompt
function precmd() {
  local s=$(echo $s 2>/dev/null ) 
  echo precmd
  fc -l 1 | tail -1
  echo --------
  if [[ $s -eq 0 ]];then
    STATUS_COLOR='%F{46}'  # Green is true.
  else
    STATUS_COLOR='%F{196}' # Red is false.
  fi
  if [[ "$last_cmd" == 'git'  ]]  ; then vcs_info; fi
  if [[ "$last_cmd" =~ 'vi.*'  ]]  ; then vcs_info; fi
  if [[ "$last_cmd" =~ '.*\>.*' ]]  ; then vcs_info; fi
  if [[ "$last_cmd" == 'cd'   ]]  ; then vcs_info; fi
  PREPWD=$(pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!')
  vcs_info
  PROMPT="${STATUS_COLOR}${ZSH_WORKSPACE}:${PREPWD}%F{013}"'${vcs_info_msg_0_}'"%F{154} -> ${TASK} %F{reset}
%F{250}%T %F{207} ~ %F{reset} "
  new_term_time=$(date +%s)
  #last_cmds=$(fc -l -1 | head -n1 | cut -c8-)
  #last_cmd=$(echo $last_cmds | cut -d' ' -f1)
  if [[ $(( $new_term_time - $term_time )) -gt $notifySec ]] && [[ -f ~/.slackrc ]];then
  #notify-send
  fi
  term_time=$new_term_time
}
## preexec: before exec command.
function preexec() {
  echo preexec
  echo -n ${1%%$}
  echo -----
  fc -l | tail -1
}
## periodic: polling with PERIOD sec.
PERIOD=5
function periodic() {

}
#####
autoload -Uz add-zsh-hook
add-zsh-hook chpwd chpwd
add-zsh-hook periodic periodic
#add-zsh-hook precmd precmd
add-zsh-hook preexec preexec
add-zsh-hook zshaddhistory zshaddhistory
########################################################################
#PREPWD=$(pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!')
# PROMPT="
# %F{154}${ZSH_WORKSPACE}:%F{207}${PREPWD}%F{013}"' ${vcs_info_msg_0_}'"%F{reset}
# %F{250}%T %F{207} ~ %F{reset} "
#RPROMPT="%F{190}"'${MEMO}'"%F{reset}"
precmd
######################################################
# TODO: ZSH Auto Update to Extension.
: "Check Update"
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
    # バックグラウンドで実行
  zsh_update &! # bash の & disown 相当

: "Define Function"

: "Note Command"
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
: "zshaddhistory Process"
mkdir -p "$ZSH_HIST_DIR"

# zshaddhistory call  before running command
zshaddhistory() {
  # TODO: ESCAPE Variable
  #################################
  # CMD HTML HISTORY
  local now_date="$(date +'%Y-%m-%d')"
  local now_time="$(date +'%H:%M:%S')"
  local now_epoc="$(date +'%s')"
  local hist_file="$ZSH_HIST_DIR/${now_date}.html"
  test -e "$hist_file" || echo "<h1>$now_date</h1><table border=\"1\"><tr><th>Time</th><th>WD</th><th>Cmd</th><th>Spend</th></tr>" >> "$hist_file"
  echo "<tr><td><time datetime=\"$now_time\">$now_time</time></td><td>$PWD</td><td><pre>" >> "$hist_file"
  echo -n ${1%%$} >> "$hist_file"
  echo "</pre></td></tr>" >> "$hist_file"
}


# Memo書き込み関数(alias @write)
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

# For Hyper Terminal
function title() { echo -e "\033]0;${1:?please specify a title}\007" ; }
function @reload(){
  export  MEMO=$(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)
}
# for Weather
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

_exit_function(){
  memo_write
  # PPIDが`init`でRunningしているWSLの場合は、Exit 0で切らせる。
  test "$(ps -o comm "$PPID" | tail -n1)" = "init" && return 0
}


trap "_exit_function" EXIT INT

#Custom Config
for i in $(/bin/ls -1 "${ZDOTDIR}/custom-enable.d")
do
    source "${ZDOTDIR}/custom-enable.d/${i}"
done
# Custom.d
for i in $(/bin/ls -1 "${ZDOTDIR}/custom.d")
do
    source "${ZDOTDIR}/custom.d/${i}"
done



# ファイル上のメモを参照
declare -g  MEMO=$(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)

#source $ZDOTDIR/logout.sh
#alias exit="_logout; exit"
alias exit="source ${ZDOTDIR}/.zlogout; exit"

rm $ZLOCKFILE
# Tmux Auto Run
if [[ -v TMUX_AUTO_START_ENABLE ]];then
  if [[ $isRunningTmux -eq 0 ]];then
    # new Tmux.
   export ZSH_TMUX_SESSNAME="ses-$(date +'%Y%m%d-%H%M%S')"
   tmux new -s "$ZSH_TMUX_SESSNAME"
  fi
fi
