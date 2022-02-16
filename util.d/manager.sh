#!/bin/bash -eu
ca="${ZDOTDIR}/custom-available.d/"
ce="${ZDOTDIR}/custom-enable.d/"
names=$(find "$ca" -type f | xargs -L1 basename |sed -e 's;\..*sh$;;g')
checklists="--checklist PluginSelector 100 100 100"
while read -r name
do
	cap="${ca}${name}.sh"
	cep="${ce}${name}.sh"
	# #Description:
	# TODO: 厳密一致
	set +e
	desc="$(grep -F -i 'description:' "$cap"  | head -1  | sed -e 's;^.*Description:\ *;;g')"; 2>/dev/null
	#desc="$(grep -F 'Desc' "$cap" )"
	set -e
	if [[ "" == "$desc" ]];then
		desc="Description Undefined."
	fi
	bool="off"
	if [[ -s "$cep" ]];then
		bool="on"
	fi
	echo "listup... [$name] - $desc"
	checklists="${checklists} \"$name\" \"${desc}\" ${bool}"
done <<< "$names"
find "$ce" -type l | xargs -r rm -v


exec 3>&1
enables="$(eval "dialog $checklists" 2>&1 1>&3)"
exec 3>&-
clear

echo "$enables" | tr ' ' '\n' | while read -r name
do
	cap="${ca}${name}.sh"
	cep="${ce}${name}.sh"
	#desc="$(grep -P '^\ *?#\ *?Descripton:.*$' "$cap" | head -1  | sed -e 's;^.*?Description:;;g')"; 2>/dev/null
	ln -s "$cap" "$cep"
	echo "Enabled: $name"
done
