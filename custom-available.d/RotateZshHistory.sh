#Description: zsh history rotate
export ZTTY_FEATURES="RotateZshHistory:${ZTTY_FEATURES}"
export ZSH_HIST_ROTATEDATE="$HOME/.zsh_historys/update"
export ZSH_HIST_BACKUPDIR="$HOME/.zsh_historys"

mkdir -p "$ZSH_HIST_BACKUPDIR"


if [[ ! -f "$ZSH_HIST_ROTATEDATE" ]];then
  date '+%Y-%m-%d' > "$ZSH_HIST_ROTATEDATE"
fi

#########################################

_zsh_hist_rotate(){
  local tmp=$(mktemp -u -p "/dev/shm")
  history -i -E 1 | awk '{print $2}' | sort | uniq | while read d
  do
    local out="${ZSH_HIST_BACKUPDIR}/${d}.log"
    history -i -E 1 | grep -P '^\ *?[0-9]*?\ \ '"$d" | sed -e 's;^\ *[0-9]*\ *;;g' >> "$out"
    cp "$out" "$tmp"
    sort $tmp | uniq > $out
  done
}

#########################################

_zsh_hist_check(){
  local n="$(date '+%Y-%m-%d')"
  local d="$(cat $ZSH_HIST_ROTATEDATE)"
  if [[ "$d" != "$n" ]];then
    : "diff $n <--> $d"
	_zsh_hist_rotate && \
    date '+%Y-%m-%d' > "$ZSH_HIST_ROTATEDATE"
  else
    : "nodiff $n == $d"
  fi
}

#########################################

_zsh_hist_search(){
 # Impl. yet.
}

_zsh_hist_check
