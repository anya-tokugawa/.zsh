echo "Opts: $-"
echo "-----------------------------"
for i in $(echo $- | fold -1 )
do
	zsh --help | grep "\-${i} "
done
echo "-----------------------------"
