# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

umask 022

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gnzh"

# Cygwin Alliases
if [[ $(uname -o) == "Cygwin" ]]; then
  alias sudo=''
  alias apt-get='apt-cyg'
  alias atom='atom.cmd'
  alias apm='apm.cmd'
  alias ruby='cmd /c ruby'
  alias rake='cmd /c rake'
  alias rails='cmd /c rails'
  alias rspec='cmd /c rspec'
  alias gem='cmd /c gem'
  alias bundle='cmd /c bundle'
fi

# Local zshrc extension
if [ -d "${HOME}/.local/etc" ] && [ -f "${HOME}/.local/etc/zshrc" ]; then
  source "${HOME}/.local/etc/zshrc"
fi

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins+=(git)
if which rails > /dev/null; then
  plugins+=(rails)
fi
if which python > /dev/null; then
  plugins+=(python)
fi

# User configuration

source $ZSH/oh-my-zsh.sh

[[ -x /usr/bin/dircolors && -r ~/.dircolors ]] && eval "$(dircolors ~/.dircolors)"

if [[ -x /usr/local/bin/virtualenvwrapper.sh ]]; then
  export WORKON_HOME=${HOME}/.local/share/venvs

  if which python3 > /dev/null; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
  else
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
  fi

  export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv

  source /usr/local/bin/virtualenvwrapper.sh
fi
