PATH_LIST=$(cat << EOF | xargs | sed -e 's/\ /:/g'
$HOME/bin
$HOME/.local/bin
$HOME/local/bin
$HOME/go/bin
$HOME/.cargo/bin
$HOME/.nesc/bin
EOF
)
export PATH="$PATH_LIST:$PATH"
PATH_LIST=$(cat << EOF | xargs | sed -e 's/\ /:/g'
$HOME/lib
$HOME/.local/lib
$HOME/local/lib
EOF
)
export LD_LIBRARY_PATH="$PATH_LIST:${LD_LIBRARY_PATH}"
# .local/packages
for i in $(/bin/ls -1 $HOME/.local/packages/)
do
  export PATH="$HOME/.local/packages/${i}/bin:$PATH"
  export LD_LIBRARY_PATH="${HOME}/.local/packages/${i}/lib:${LD_LIBRARY_PATH}"
  export LD_LIBRARY_PATH="${HOME}/.local/packages/${i}/lib64:${LD_LIBRARY_PATH}"
done
