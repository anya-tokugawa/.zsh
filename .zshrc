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
    if [ $# -eq 0 ];
    then
        unset MEMO
        return
    else
        for text in $@
        do
            declare -g MEMO="${MEMO} ${text}"
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


function shutdownproc(){
    if test "$MEMO" = ""
    then
        echo '' > ${ZDOTDIR}/MEMO.txt
    else
        for i in $(echo $MEMO | xargs)
        do
            local exist_flag=0
            for x in $(cat ${ZDOTDIR}/MEMO.txt | xargs)
            do
                if test "$i" = "$x"
                then
                    exist_flag=1
                fi
            done
            if test $exist_flag -eq 0
            then
                 echo "memo: add - $i"
                 echo $i >> ${ZDOTDIR}/MEMO.txt
            else
                echo "memo: exist - $i"
            fi
        done
    fi
    exit 0
}
function @reload(){
    MEMO=$(cat ${ZDOTDIR}/MEMO.txt | xargs)
}
trap "shutdownproc" EXIT INT
MEMO=$(cat ${ZDOTDIR}/MEMO.txt | xargs)

