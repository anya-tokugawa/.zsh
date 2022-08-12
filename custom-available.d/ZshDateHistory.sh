#Description: zsh history rotate with date, time, tmux when occured with .zlogout
export HISTBASEDIR="${ZDOTDIR}/historys"

# call from .zlogout
_writeHistoryWithDate(){
t1=""
if [[ -v TMUX_PANE ]];then
  t="-$(tmux display-message -p '#S--#W')" # sessionname--windowname
fi
t2="$(echo "$TTY" | tr '/' '-')" # -dev-pts-0
t3="$(date +'%Y-%m-%d/%H-%M-%S')"
export HISTFILE="${HISTBASEDIR}/${t3}${t2}${t1}.log"
mkdir -p "$(dirname "$HISTFILE")"
fc -W # Write History
}
_histinclude(){
find "$HISTBASEDIR" -type f -name "*.log" | sort | xargs -I% cat % > "${ZDOTDIR}/.zsh_history" 2>/dev/null

}

hs(){
  set -x
  hstr
  set +x
}
setopt histignorespace           # skip cmds w/ leading space from history
export HSTR_CONFIG=hicolor       # get more colors
bindkey -s "\C-r" "\C-a hstr -- \C-j"     # bind hstr to Ctrl-r (for Vi mode check doc))

_histinclude &!
export HISTFILE="${ZDOTDIR}/.zsh_history"

