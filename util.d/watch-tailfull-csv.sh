#!/bin/bash -eu
while :
do
  clear  && tail -n"$(tput lines)" $@ | column -ts,
  sleep 1

done

