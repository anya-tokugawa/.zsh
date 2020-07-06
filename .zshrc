: "PROMPT"
# 20200301:
# - /etc/zshrc にPROMPT変数が定義されている。
# - ${ZDOTDIR}/.zshenv のあとに /etc/zshrcを読み込む
# - よって、.zshenv だと上書きされてしまう事象（CentOS 7)

#PROMPT="%K{black}%F{3}${HOST} %F{cyan}<"$IP_ADDRESSES"> "'${vcs_info_msg_0_}'"%F{reset}%K{reset}
#%K{0} %F{7} [%~] %#%K{reset}%F{reset} "
#
#

case "$TERM" in
    xterm*|kterm*|rxvt*)
	function precmd () {
	vcs_info
        # Shorten the path of pwd
	PREPWD=`pwd | perl -pe 's!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!'`
	if test "$(whoami)" == "root"
	then
		PROMPT="
%F{154}${HOST}:%F{207}${PREPWD}%F{013}"' ${vcs_info_msg_0_}'"%F{reset}
%F{250}%T %F{207}#> %F{reset} "
	else
		PROMPT="
%F{154}${HOST}:%F{207}${PREPWD}%F{013}"' ${vcs_info_msg_0_}'"%F{reset}
%F{250}%T %F{207}-> %F{reset} "
	fi
	}
    ;;
esac

RPROMPT="%F{044}"'${MEMO}'"%F{reset}"

# INFO
echo "$HOST - $IP_ADDRESSES"
echo "----------------------------------"
: "Check Update"
	function zsh_update() {
        cd  $ZDOTDIR
        echo "Latest: $(git log  | head -n6 | grep 'Date' | sed 's/Date:   //')"
        OLD_ZSH_CONF_VERSION=$(git describe --abbrev=0 --tags   )
        git pull  > /dev/null 2>&1
        ZSH_CONF_VERSION=$(git describe --abbrev=0 --tags  )
        if [[ $? -eq 0 ]]
        then
            if [ $OLD_ZSH_CONF_VERSION != $ZSH_CONF_VERSION ]
            then
                echo "ZLOG: ZSH UPDATED - NEW_VERSION: $ZSH_CONF_VERSION - $(git log | head -6 | grep 'Date' | sed 's/Date:   //')(Plz Reload Settings)"
            fi
        fi
    }
    # バックグラウンドで実行
    zsh_update &! # bash の & disown 相当
: "Define Function"
    function chpwd() {
        ls -F
    }
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

# 2020-02-24: catコマンドを拡張子別に変更
function cat(){
    # ヒアドキュメント判定
    if test "`echo $@ | grep 'EOF' | grep '<<' `"  -eq 0
    then
        /bin/cat $@
        return
    else
        # 複数ファイルを判定しない
        if [ $# -eq 1 ];
        then
            # PlainTextなファイル
            if [ "`file $1 | grep 'text'`" ];
            then
                # 拡張子別に振り分け
                case "$1" in
                    *.csv ) column -ts, $1 | nl ;;
                    *.md  ) mdcat $1 | nl ;;
                    *     ) /bin/cat $1 | nl ;;
                esac
            else
                /bin/cat $1 | nl
            fi
        else
            /bin/cat  $@ | nl
        fi
    fi
}

# Pecoを用いたlisted Change Directory.
function lscd {
    local dir="$( ls -1A | grep "/" |  peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
    fi
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




# ファイル上のメモを参照
declare -g  MEMO=$(/bin/cat ${ZDOTDIR}/MEMO.txt | xargs)
