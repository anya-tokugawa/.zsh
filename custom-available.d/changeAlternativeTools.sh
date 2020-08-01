
_hasCommand () {
  type "$1" > /dev/null 2>&1 && return 0
  return 1
}

if _hasCommand exa ; then 
  alias ls="exa"
  alias la="exa -a" ; fi
if _hasCommand fd  ; then alias find="fd" ; fi
