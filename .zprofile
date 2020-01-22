autoload -U compinit   && compinit
autoload -U promptinit &&  promptinit
#autoload -U predict-on &&  predict-on
autoload history-search-end
autoload colors

: "Some Setting load"

: "Load setopt";  source .zsh_options
: "Load KeyBind"; source .zsh_keybind
: "Load Aliases"; source .zsh_aliases
