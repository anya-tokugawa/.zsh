#compdef pass
#autoload

_dcomp() {
    compadd $(dstask _completions "${words[@]}")
}

compdef _dcomp d
