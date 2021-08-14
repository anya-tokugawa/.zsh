export ZSH_HIST_ROTATEDATE="$HOME/.zsh_historys/update"
export ZSH_HIST_BACKUPDIR="$HOME/.zsh_historys"
mkdir -p "$ZSH_HIST_BACKUPDIR"

if [[ ! -f "$ZSH_HIST_ROTATEDATE" ]];then
  date '+%Y-%m-%d' > "$ZSH_HIST_ROTATEDATE"
fi

_zsh_hist_rotate(){
  local d="$1" # YYYY-MM-DD
    history -i -E 1 | grep -P '^\ *?[0-9]*?\ \ '"$d" | sed -e 's;^\ *[0-9]*\ *;;g' |  tee ${ZSH_HIST_BACKUPDIR}/${d}.log
}
_zsh_hist_check(){
  local n="$(date '+%Y-%m-%d')"
  local d="$(cat $ZSH_HIST_ROTATEDATE)"
  if [[ "$d" != "$n" ]];then
	_zsh_hist_rotate && date '+%Y-%m-%d' > "$ZSH_HIST_ROTATEDATE"
  fi


}
_zsh_hist_rotate_all(){
  history -i -E 1 | awk '{print $2}' | sort | uniq | while read d
  do
    history -i -E 1 | grep -P '^\ *?[0-9]*?\ \ '"$d" | sed -e 's;^\ *[0-9]*\ *;;g' > ${ZSH_HIST_BACKUPDIR}/${d}.log
  done
}

_zsh_hist_search(){
 # Impl. yet.
}

_zsh_hist_check
