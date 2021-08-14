
_scLinkDir="$HOME/links/"
_ttyName=$(echo "$TTY" | sed 's;^/dev/;;g' | tr '/' '-' ) # pts-1
export ZSH_SCLINK_FILE="${_scLinkDir}${_ttyName}.source"

# inherit original chpwd config
org="$(which chpwd | tail -n +2 | sed -e '$ d')"

# *.source file is run with source cmd
# alias -s source=source

chpwd=$( cat << HERE
function chpwd(){
  # NOTE: add impl. current dir link.
  # HACK: TODO: How do make shortcut w no symlink, no hardlink.
  echo "cd \$PWD && echo \" - Jumping Done! : \$PWD\"" > "\$ZSH_SCLINK_FILE"
  echo a+x "\${ZSH_SCLINK_FILE}"
  $org
}
HERE
)

eval $chpwd
