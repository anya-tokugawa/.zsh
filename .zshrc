source $ZDOTDIR/config

: "PROMPT"
# 20200301:
# - /etc/zshrc にPROMPT変数が定義されている。
# - ${ZDOTDIR}/.zshenv のあとに /etc/zshrcを読み込む
# - よって、.zshenv だと上書きされてしまう事象（CentOS 7)

#PROMPT="%K{black}%F{3}${HOST} %F{cyan}<"$IP_ADDRESSES"> "'${vcs_info_msg_0_}'"%F{reset}%K{reset}
#%K{0} %F{7} [%~] %#%K{reset}%F{reset} "
#
#
PREPWD=''
function precmd () {
      if [[ $? -eq 0 ]]
      then
        STATUS_COLOR='%F{46}'  # Green is true.
      else
        STATUS_COLOR='%F{196}' # Red is false.
      fi
      last_cmds=$(fc -l -1 | head -n1 | cut -c8-)
      last_cmd=$(echo $last_cmds | cut -d' ' -f1)
      if [[ "$last_cmd" == 'git'  ]]  ; then vcs_info; fi
      if [[ "$last_cmd" =~ 'vi.*'  ]]  ; then vcs_info; fi
      if [[ "$last_cmd" =~ '.*\>.*' ]]  ; then vcs_info; fi
      if [[ "$last_cmd" == 'cd'   ]]  ; then vcs_info; fi
      PREPWD=$(pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!')
      PROMPT="${STATUS_COLOR}${ZSH_WORKSPACE}:${PREPWD}%F{013}"'${vcs_info_msg_0_}'"%F{154} -> ${TASK} %F{reset}
%F{250}%T %F{207} ~ %F{reset} "

}
vcs_info
PREPWD=$(pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!')
PROMPT="
%F{154}${ZSH_WORKSPACE}:%F{207}${PREPWD}%F{013}"' ${vcs_info_msg_0_}'"%F{reset}
%F{250}%T %F{207} ~ %F{reset} "




#test
#add-zsh-hook precmd vcs_info

if test "$(whoami)" == "root"
then
cat <<ATTENT
====================
HELLO ADMIN PROMPT!
====================
ATTENT
fi
RPROMPT="%F{190}"'${MEMO}'"%F{reset}"


# INFO
#echo "$HOST - $IP_ADDRESSES"
#echo "----------------------------------"
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
    function chpwd() { test $(/bin/ls -1 | wc -l) -gt 10 && ls || ll }
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
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
    #　三行以下のコマンドのみ格納
	test $(echo ${line} |grep -o '\n' |wc -l)  -lt 3
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
trap "memo_write" EXIT INT

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
