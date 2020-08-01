# .zsh

My ZSH Configuration

## Abst.

- zsh my settings
- no third-party extensions(e.g. oh-my-zsh)
- custom-shell-extension in `custom-available.d/` ( symlink to `custom-enable.d/`)
- terminal short note (called `memo`)  extension

## Dependency(Alias)

- zsh

## Install

```bash
git clone https://github.com/Eric-lightning/.zsh $HOME/
ln -s $HOME/.zsh/.zshenv $HOME/
cd $HOME/.zsh
chmod x setup.sh
./setup.sh
chsh -s /bin/zsh
```

## Feature

### Memo Feature

`@`Command is for prompt-note.

```sh
% @ Hello World
memo buffer added: Hello
memo buffer added: World
%                                Hello World
% @ -Hello                       Hello World
memo buffer removed: Hello
%                                      World
% @ GoodMorning World                  World
memo buffer added: GoodMorning
memo buffer exist: World
%                           World GoodMorning
% @ -World
% @write                          GoodMorning
memo: add - GoodMorning
% cat ~/.zsh/MEMO.txt
001:| GoodMorning
% @write
memo: exist - GoodMorning
```

### Other Plugins

- enable Plugin

```sh
cd .zsh
,/enablePlugin.sh custom-available.d/[Plugin_File_name]
```


#### AutoCloseConsoleChecker(A3C) - `autoCloseConsole.sh`

If it is not running when bowling 4 count per 30sec,
auto-close terminal(`kill -9 $TERMINAL_PID`)

- `autoexit` ... enable A3C
- `noautoexit` ... disable A3C

#### WSL - Windows StartupDir Detection - `wsl-autocd-detectWinStartup.sh`

If you run WSL by AutoHotKey(etc...) at Windows StartupDir,
this feature detected and change-directory to HomeDir.

#### terminal Timer - `termTimer.sh`

- Timer in background using `sleep`
- usage: `timer [sleep_secounds]`
- store running timer info to `~/.timer.csv`
- list running timer: `lstimer`

#### sudo aliases - `sudo.sh`

- if `sudo apt`: -> alias to `apt-fast`
- else: `sudo [other_args]`

#### dstask aliases - `dstask.sh`

- dstask custom command

```
$2 ... sh || show
$3 ... and

d sh pr || pro      ... dstask show-projects
d    ta || tags     ...            -tags
d    ac || now      ...            -active
d    pa || stopped  ...            -paused
d    re || resolved ...            -resolved
d    un || untagged ...            -organised
```

- else: `dstask [other_args]`


## Design

![zsh design 20200701](lib/zsh.jpg)

