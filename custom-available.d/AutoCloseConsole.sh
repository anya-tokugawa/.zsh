#Description: Auto Close Console when no running 5min
export ZTTY_FEATURES="AutoCloseConsole:${ZTTY_FEATURES}"
# Auto Close Console Feature
# 30s * 4 -> 120s = 2min
A3C_STARTUP=1
# CheckBowlingTime
BOW_TIME=5
CHECK_BOW=60




ZTTY_PID=$$
ZTTY_PATH=$TTY
# Check Process
function AutoCloseConsoleChecker(){
    NO_RUN_FLAG=0
    while :
    do
        # CheckBowling per 30 seconds.
        sleep $BOW_TIME
        # get Process
        RUNNING_JOBS=$(ps)
        # filtered ps and zsh and HEADER
        FIX_RUNNING_JOBS=$(echo $RUNNING_JOBS | tail -n +2 | grep -v 'zsh' | grep -v 'ps')
        if [[ "$FIX_RUNNING_JOBS" == "" ]]
        then
            if [[ $NO_RUN_FLAG -gt $CHECK_BOW ]]
            then
                break
            else
                if [[ $NO_RUN_FLAG -eq $CHECK_BOW ]]
                then
                    echo ""
                    echo "AUTO_EXIT -> $AUTO_EXIT"
                    echo ">>> DETECT NO RUN - WILL SOON ALIVE EXIT (if u want to be not exit, plz run 'noautoexit' )" > $ZTTY_PATH
                fi
                let NO_RUN_FLAG++
            fi
        else
            NO_RUN_FLAG=0
        fi
    done
    kill -9 $ZTTY_PID
}

if [ $A3C_STARTUP -eq 1 ]
then
    echo -n "A3C STARTUP Enabled - "
    AutoCloseConsoleChecker &
    A3C_PID=$!
    export ZTERM_A3C_PID=$A3C_PID
fi
alias autoexit='noautoexit ; wait && echo -en "\e[38;5;082m A3C" ; AutoCloseConsoleChecker & A3C_PID=$!'
function noautoexit(){
    if [[ "$A3C_PID" != "" ]] && [[ $(ps $A3C_PID | tail -n +2) != "" ]]
    then
            echo -en "\e[38;5;196m A3C" ; kill -9 "$A3C_PID"
    fi
}

