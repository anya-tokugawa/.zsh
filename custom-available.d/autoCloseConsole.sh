# Auto Close Console Feature
# 30s * 4 -> 120s = 2min
CHECK_BOL=4

ps ao ppid,cmd | grep -v 'grep' | grep 'ps ao ppid,cmd' | awk '{print $1}' | read ZTTY_PID
ZTTY_PATH=$TTY

# Check Proc
function AutoCloseConsoleChecker(){
    NO_RUN_FLAG=0
    while :
    do
        sleep 30
        RUNNING_JOBS=$(ps)
        FIX_RUNNING_JOBS=$(echo $RUNNING_JOBS | tail -n +2 | grep -v 'zsh' | grep -v 'ps')
        if [[ "$FIX_RUNNING_JOBS" == "" ]]
        then
            if [[ $NO_RUN_FLAG -gt $CHECK_BOL ]]
            then
                break
            else
                echo ""
                if [[ $NO_RUN_FLAG -eq $CHECK_BOL ]]
                then
                    echo ">>> DETECT NO RUN - WILL SOON ALIVE EXIT" > $ZTTY_PATH
                fi
                let NO_RUN_FLAG++
            fi
        else
            NO_RUN_FLAG=0
        fi
    done
    kill -9 $ZTTY_PID
}
(AutoCloseConsoleChecker &) > /dev/null 2>&1

alias exit="kill -9 $CPID ; exit 0"

