#!/bin/bash -eu
ca="custom-available.d/"

cat << HEADER
| Name | Description |
|------|-------------|
HEADER

while read -r fname
do
  name="${ca}${fname}"
	# #Description:
	# TODO: 厳密一致
	set +e
	desc="$(grep -F -i 'description:' "$name"  | head -1  | sed -e 's;^.*Description:\ *;;g')"; 2>/dev/null
	set -e
	if [[ "" == "$desc" ]];then
		desc="Description Undefined."
	fi
	echo "| $fname | $desc |"
done < <(/bin/ls -1 "$ca" ) | sort
