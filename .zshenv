: "ZSH ENV DIRECTORY (NEED TO LINK 'ln -s /HomeDir/.zsh/.zshrnv /HomeDir/.zshenv'"
export ZDOTDIR=$HOME/.zsh

# auto load
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}(!)%F{red}"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}(?)%F{red}"
zstyle ':vcs_info:*' formats "%F{green}^%b%c%u%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

: "ZSH HISTORY"
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000

: "PATH"
for i in `ls -1 --file-type "${ZDOTDIR}/include.d"`
do
  source "${ZDOTDIR}/include.d/${i}"
done

: "HOST ALIASES"
export HOSTALIASES="~/.hosts"

: "LOCATION"
export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"
export LANGUAGE="ja"

: "DEFAULT EDITOR"
export EDITOR=`which vim`
: "DEFAULT PAGEOR"
export PAGEOR=`which more`

: "IP_ADDRESS"
#declare -a -x IP_ADDRESSES
#IP_ADDRESSES=$(ip a | grep inet | grep -ve inet6 -e 127.0.0. | awk '{print $2}'| xargs)

: "OUTPUT DISPLAY"
export DISPLAY=":0"

: "GIT ACCESS FS"
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1


export ZSH_TASKS="${HOME}/.ztasks"
: "Load Profile"
source $ZDOTDIR/.zprofile
