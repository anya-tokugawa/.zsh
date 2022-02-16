# Description: dstask completions
export ZTTY_FEATURES="DstaskZshCompletions:${ZTTY_FEATURES}"
#compdef pass
#autoload

_dcomp() {
    compadd $(dstask _completions "${words[@]}")
}

compdef _dcomp d
