export ZTTY_FEATURES="Txt2Pdf:${ZTTY_FEATURES}"
function txt2pdf(){
  if [[ $# -ne 2 ]]
  then
    echo "usage: txt2pdf [input.txt] [output.pdf]"
    echo "dependency-command: enscript, ps2pdf, rm"
    return
  fi
  enscript $1 --output=$1.ps && ps2pdf $1.ps $2 && rm $1.ps
}
