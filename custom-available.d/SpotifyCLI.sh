export ZTTY_FEATURES="SpotifyCLI:${ZTTY_FEATURES}"
if $(spotify > /dev/null 2>&1 ); then
  function -next     { spotify next   $@ }
  function -pause    { spotify pause  $@ }
  function -play     { spotify play   $@ }
  function -previous { spotify previous  $@ }
  function -queue    { spotify queue  $@ }
  function -repeat   { spotify repeat  $@ }
  function -shuffle  { spotify shuffle  $@ }
  function -vol      { spotify volume  $@ }
  function -status   { spotify status  $@ }
  function -history  { spotify history  $@ }
  function -search   { spotify search  $@ }
  function -top      { spotify top  $@ }
  function -save     { spotify save  $@ }
  function -help {
    echo "-next -pause -play -previous -queue -repeat -shuffle -vol -status -history -search -top -save -help"
  }
fi
