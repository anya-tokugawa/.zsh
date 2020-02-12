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
    zsh_update
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
function shutdownproc(){
    if test  $MEMO = ''
    then
        echo '' > ${ZDOTDIR}/MEMO.txt
    else
        echo $MEMO >> ${ZDOTDIR}/MEMO.txt
    fi
    exit 0
}
function @reload(){
    MEMO=$(cat ${ZDOTDIR}/MEMO.txt | xargs)
}
trap "shutdownproc" EXIT INT
MEMO=$(cat ${ZDOTDIR}/MEMO.txt | xargs)

