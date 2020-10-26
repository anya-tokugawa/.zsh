# LINUX_BREW_PATH SETTING 2020-06-05

_BREW_DIR="$HOME/.linuxbrew"

export     HOMEBREW_PREFIX="${_BREW_DIR}/Homebrew";
export     HOMEBREW_CELLAR="${_BREW_DIR}/Homebrew/homeCellar";
export HOMEBREW_REPOSITORY="${_BREW_DIR}/Homebrew";
export PATH="${_BREW_DIR}/Homebrew/bin:${_BREW_DIR}/Homebrew/sbin:${PATH}";
export MANPATH="$_BREW_DIR}/Homebrew/share/man:${MANPATH}";
export INFOPATH="${_BREW_DIR}/Homebrew/share/info${INFOPATH}";

