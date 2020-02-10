: "ZSH ENV DIRECTORY (NEED TO LINK 'ln -s /HomeDir/.zsh/.zshrnv /HomeDir/.zshenv'"
export ZDOTDIR=$HOME/.zsh

: "ZSH HISTORY"
export HISTFILE=${ZDOTDIR}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000

: "PATH"
export PATH=$PATH":"$(cat << EOF | xargs | tr ' ' ':'
/home/linuxbrew/.brew/bin
/home/linuxbrew/.linuxbrew/bin
$HOME/.brew/bin
$HOME/.linux/brew/bin
$HOME/local/bin
$HOME/.local/bin
EOF
)

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
export IP_ADDRESS=`hostname -i | cut -d' ' -f1`

: "PROMPT"
PROMPT="%F{green}${HOST}%F{cyan}%#:%F{reset}"
# RPROMPT='%F{yellow}%!%F{reset} - %F{cyan}%*%F{reset}'

: "OUTPUT DISPLAY"
export DISPLAY=":0"

: "Load Aliases"; source $ZDOTDIR/.zsh_profile