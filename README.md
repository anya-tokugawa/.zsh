# .zsh

My ZSH Configuration

## Dependency(Alias)

- linuxbrew
 - [Peco](https://github.com/peco/peco)
 - [mdcat](https://github.com/lunaryorn/mdcat)

## Install

```bash

git clone https://github.com/Eric-lightning/.zsh $HOME/
cd $HOME/.zsh
bash setup.sh
```

## Feature

### RPROMPT MEMO
``` bash
 [~] % : RPROMPT_MEMO
DPC00 <172.22.1.61/24> 
 [~] % : ADD && @ Hello World
memo buffer added: Hello
memo buffer added: World
DPC00 <172.22.1.61/24> 
 [~] % : REMOVE && -Hello                                                                             Hello World
zsh: command not found: -Hello
DPC00 <172.22.1.61/24> 
 [~] % : REMOVE &&  @ -Hello                                                                          Hello World
memo buffer removed: Hello
DPC00 <172.22.1.61/24> 
 [~] % : WRITE && @write                                                                                    World
memo: add - World
DPC00 <172.22.1.61/24> 
 [~] %                                                                                                      World
DPC00 <172.22.1.61/24> 
 [~] % : IF EXIST && @ World                                                                                World
memo buffer exist: World
DPC00 <172.22.1.61/24> 
 [~] % : WRITE IF EXIST && @write                                                                           World
memo: exist - World
DPC00 <172.22.1.61/24> 

# --------------------------------

DPC00 <172.22.1.61/24> 
 [~] % : SAVE LOCATION && cat .zsh/MEMO.txt                                                                              Test1 Test2
001:| Test1 
002:| Test2
DPC00 <172.22.1.61/24> 
 [~] %                
