# Descripton: WSL Auto ChangeDirt to HOME
export ZTTY_FEATURES="WslAutoChangeDir:${ZTTY_FEATURES}"
# DETECT WINDOWS STARTUP_PATH
if [[ "$PWD" =~ "/mnt/c/.*/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup" ]]
then
	cd $HOME >> /dev/null
fi
# If Windows Terminal
if [[ "$PWD" =~ "/mnt/c/.*/eric" ]]
then
	cd $HOME >> /dev/null
fi
if [[ "$PWD" =~ "/mnt/c/Windows/system32" ]]
then
	cd $HOME >> /dev/null
fi
