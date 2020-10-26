#!/bin/bash -eu

max=100
sum=0.0

for i in $(seq 1 $max)
do
  avg="$( (time zsh -i -c exit) 2>&1 | grep 'real' | awk '{print $2}' | sed -s 's;0m;;g' | tr -d 's')"
  echo "*"
  sum="$(echo "$sum + $avg" | bc)"
done

echo "scale=4; $sum / $max.0" | bc
