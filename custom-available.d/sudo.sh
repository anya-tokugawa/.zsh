sudo() {
  if [ "$1" ==  "apt" ]; then
    shift
    /usr/bin/sudo apt-fast "$@"
  else
    /usr/bin/sudo "$@"
  fi
}
