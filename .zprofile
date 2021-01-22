autoload -Uz compinit &&  compinit -C
autoload -U promptinit && promptinit
autoload -Uz add-zsh-hook

#autoload -U predict-on &&  predict-on
autoload history-search-end
autoload colors

: "Some Setting load"

: "Load setopt"
source $ZDOTDIR/.zsh_options
: "Load KeyBind"
source $ZDOTDIR/.zsh_keybind
: "Load Aliases"
source $ZDOTDIR/.zsh_aliases
