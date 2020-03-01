: "PROMPT"
# 20200301: 
# - /etc/zshrc にPROMPT変数が定義されている。
# - ${ZDOTDIR}/.zshenv のあとに /etc/zshrcを読み込む
# - よって、.zshenv だと上書きされてしまう事象（CentOS 7)
PROMPT="%K{black}%F{3}${HOST} %F{cyan}<"$IP_ADDRESSES"> "'${vcs_info_msg_0_}'"%F{reset}%K{reset}
%K{0}%F{7} [%~] %#%K{reset}%F{reset} "
RPROMPT="%K{black}%F{red}"'${MEMO}'"%F{reset}%K{reset}"
: "Check Update"
	function zsh_update() {
		cd $HOME/.zsh
        OLD_ZSH_CONF_VERSION=$(git describe --abbrev=0 --tags)
        git pull origin > /dev/null 2>&1
        ZSH_CONF_VERSION=$(git describe --abbrev=0 --tags)
        if [[ $? -eq 0 ]]
        then
            if [ $OLD_ZSH_CONF_VERSION != $ZSH_CONF_VERSION ]
            then
                echo "ZSH UPDATED - NEW_VERSION: $ZSH_CONF_VERSION (Plz Reload Settings)"
            fi
        fi
    }
    zsh_update &! # bash の & disown 相当
: "Define Function"
cd $HOME
function chpwd() {
    ls -F
} # auto display list directory after changed director

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

zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
	test $(echo $line|grep -o '\n'|wc -l) -lt 3

    # 以下の条件をすべて満たすものだけをヒストリに追加する
#    [[ ${#line} -ge 5
#       && ${cmd} != (l|l[sal])
#       && ${cmd} != (c|cd)
#       && ${cmd} != (m|man)
#   ]]
}

# 2020-02-24: catコマンドを拡張子別に変更
function cat(){
    if test "`echo $@ | grep 'EOF' | grep '<<' `"  -eq 0
    then
        # ヒアドキュメント対策
        /bin/cat $@
        return
    else
        if [ $# -eq 1 ];
        then
            if [ "`file $1 | grep 'text'`" ];
            then
                case "$1" in
                    *.csv ) column -ts, $1 | nl ;;
                    *.md ) mdcat $1 | nl ;;
                    *) /bin/cat $1 | nl ;;
                esac
            else
                echo "Type 1"
                /bin/cat $1 | nl
            fi
        else
            echo "Type 3"
            /bin/cat  $@ | nl
        fi
    fi
}

function lscd {
    local dir="$( ls -1A | grep "/" |  peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
    fi
}
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
declare -g  MEMO=$(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)

