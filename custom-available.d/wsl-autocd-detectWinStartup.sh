# DETECT WINDOWS STARTUP_PATH
if [[ "$PWD" =~ "/mnt/c/.*/eric/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup" ]]
then
	cd $HOME >> /dev/null
fi
