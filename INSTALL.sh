#!/bin/bash -eu

# Dependency

sudo apt install \
    zsh \
    language-pack-ja \
    perl

curl -L git.io/antigen > $HOME/.zsh/custom-available.d/antigen.zsh
ln -s $HOME/.zsh/.zshenv $HOME/

mkdir -p $HOME/.zsh/custom-enable.d/
mkdir -p $HOME/.zsh/custom.d/

cat <<EOF
+----------------------+
| SETUP SUCCESSFUL !!! |
+----------------------+
EOF

