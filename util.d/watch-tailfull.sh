#!/bin/bash -eu
while :
do
  clear  && tail -n"$(tput lines)" $@
  sleep 1

done
