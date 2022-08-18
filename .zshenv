: "ZSH ENV DIRECTORY (NEED TO LINK 'ln -s /HomeDir/.zsh/.zshrnv /HomeDir/.zshenv'"
# if non-interactive is return
case $- in
    *i*) ;;
      *) return;;
esac

export ZDOTDIR=$HOME/.zsh
export ZSH_WORKSPACE="null"
export WTTR_LOCATION="tokyo"
export ZSH_BOOTMSG=0
export ZLOCKFILE="$(mktemp).zshlock"
echo "$PID" > $ZLOCKFILE

function check_booting(){
	local boot_cnt=0
	while :
	do
		sleep 1
		if [[ ! -f $ZLOCKFILE ]]
		then
			return 0
		fi
		if [[ $boot_cnt -ge 10 ]]
		then
      echo "Zsh Booting Failure....  Will Close Zsh...."
      kill -12 $$ # SIGNAL 12 is used Fallbacking.
      return 1
		fi
		boot_cnt=$((++boot_cnt))
	done
}

_bootmsg(){
  [[ $ZSH_BOOTMSG -eq 1 ]] && echo "BOOTING: $@"
}

check_booting &!

source $ZDOTDIR/config

_bootmsg "loading .zshenv"
# auto load
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}(!)%F{red}"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}(?)%F{red}"
zstyle ':vcs_info:*' formats "%r%F{green}^%b%c%u%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

: "ZSH HISTORY"
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

_bootmsg "Including PATH"
for i in `ls -1 --file-type "${ZDOTDIR}/include.d"`
do
  source "${ZDOTDIR}/include.d/${i}"
done

: "HOST ALIASES"
export HOSTALIASES="~/.hosts"

: "LOCATION"
export LANGUAGE="ja"
export LANG="ja_JP.UTF-8"
export LC_NUMERIC=C
export LC_TIME=C
export LC_MONETARY="ja_JP.UTF-8"
export LC_COLLATE="ja_JP.UTF-8"
export LC_MESSAGES=C

_bootmsg "Setting Default Command"
declare -x EDITOR=`which vim`
declare -x PAGEOR=`which more`


_bootmsg "Setting DISPLAY"
[[ -z "$DISPLAY" ]] && export DISPLAY=":0"

_bootmsg "Setting Enviroment Variables"
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export TMUX_TMPDIR="$ZDOTDIR/TMUX_SESSIONS/"
export ZSH_TASKS="${HOME}/.ztasks"
export GOPATH="${HOME}/.go/"

_bootmsg "Loading Profile"
source $ZDOTDIR/.zprofile

_bootmsg "Check and Loading Cargo Enviroment"
if [[ -f "$HOME/.cargo/env" ]];then
 source "$HOME/.cargo/env"
fi
