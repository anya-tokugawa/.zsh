# DETECT WINDOWS STARTUP_PATH
cat <<EOF

if [[ "$PWD" == "/mnt/c/Users/eric/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup" ]]
then

	cd $HOME >> /dev/null
fi
EOF
