# TMUX AUTO START

isRunningTmux=0
if [[ -v TMUX_AUTO_START_ENABLE ]];then
  echo "* Tmux Already Run(via ZshScript) SessionName: $ZSH_TMUX_SESSNAME"
  echo "** You want rename: tmux rename-session [name]"
  isRunningTmux=1
  return
fi

readonly TMUX_AUTO_START_ENABLE
export TMUX_AUTO_START_ENABLE

ppid=$PPID
while [[ $ppid -ne 0 ]];do
  cmdpath=$(ps -o cmd $ppid | tail -1  | cut -d' ' -f1| sed -e 's;\-;;g' -e 's;\+;;g')
  cmd="$(basename $cmdpath)"
  if [[ "$cmd" == "tmux" ]];then
    isRunningTmux=1
    break
  fi
  ppid=$(ps -o ppid $ppid | tail -1 | grep -o '[0-9]+')
done

if [[ $isRunningTmux -eq 1 ]];then
  echo "* Tmux already Run."
  return
fi
