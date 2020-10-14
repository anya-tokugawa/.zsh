#!/bin/bash -u
url=$(echo 'https://www.google.com
https://one.one.one.one' | shuf | head -n1)

echo "try: $url"
if [[ $(curl -fsSI $url | head -n1 | cut -d' ' -f2) -ne 200 ]]
then
  return 1
fi
return 0
