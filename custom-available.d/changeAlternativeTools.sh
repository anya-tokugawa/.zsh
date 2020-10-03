
_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

if _hasCommand exa ; then
  alias ls="exa"
  alias la="exa -a"
  alias ll='ls --git -lbghu'
fi
if _hasCommand fd  ; then alias find="fd"  ; fi
if _hasCommand bat ; then alias  cat="bat" ; fi
