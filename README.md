# .zsh

My ZSH Configuration

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

#### AutoCloseConsoleChecker(A3C)
If it is not running when bowling 4 count per 30sec,
auto-close terminal(`kill -9 $TERMINAL_PID`)

- `autoexit` ... enable A3C
- `noautoexit` ... disable A3C

#### WSL - Windows StartupDir Detection
If you run WSL by AutoHotKey(etc...) at Windows StartupDir,
this feature detected and change-directory to HomeDir.

## Design

![zsh design 20200701](lib/zsh.jpg)

