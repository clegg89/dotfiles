#!/bin/bash
###########################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
###########################

# install by default
uninstall=false
debug=false

action()
{
   ($debug && echo $@) || eval $@
}

die()
{
  echo "$@" 1>&2
  exit 1
}

usage()
{
  die "
  Usage ${0##*/} [-h|--help] [-u|--uninstall] [-d|--debug]

  Install or uninstall dotfiles to home directory.
  
  Options:
  -h, --help        Display this help message.
  -u, --uninstall  Undo a previous install instead of installing.
  -d, --debug     Output actions, do not actually perform them.
  "
}

options=$(getopt --name="${0##*/}" \
  --options="hud" \
  --longoptions="help,uninstall,debug" -- "$@")
[[ $? != 0 ]] && usage

eval set -- "${options}"
while true; do
  case "$1" in
    -h|--help) usage; shift;;
    -u|--uninstall) uninstall=true; shift;;
    -d|--debug) debug=true; shift;;
    --) shift; break;;
  esac
done

########## Variables

pushd `dirname $0` > /dev/null
dir=`pwd`              # dotfiles directory
popd > /dev/null

olddir=${dir}_old      # old dotfiles backup directory
script=${0##*/}        # Script name
ignores="${script} README.md"

##########

install_oh_my_zsh()
{
  # Install oh-my-zsh
  pushd ${HOME} > /dev/null

  if [[ ! -e ".oh-my-zsh" ]]
  then
    action sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  popd > /dev/null
}

install_submodules()
{
  pushd ${dir} > /dev/null

  action git submodule init
  action git submodule update

  popd > /dev/null
}

install_vim_and_tmux_plugins()
{
  pushd ${dir} > /dev/null

  # vim and tmux Plugin managers
  if [[ ! -e "vim/bundle/Vundle.vim" ]]
  then
    action git clone https://github.com/VundleVim/Vundle.vim.git vim/bundle/Vundle.vim
  fi

  if [[ ! -e "tmux/plugins/tpm" ]]
  then
    action git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm
  fi

  popd > /dev/null
}

backup_and_link_configs()
{
  pushd ${dir} > /dev/null

  # create dotfiles_old in homedir
  action mkdir -p ${olddir}

  for file in ./*; do
    src=${file##*/}
    dest=${HOME}/.${src}
    script=${0##*/}
    if [[ ! ${ignores} =~ ${src} ]]
    then
      if [[ -e $dest ]] 
      then
        if [[ ! -L $dest ]]
        then
          action mv ${dest} ${olddir}/${dest##*/.}
        else
          action rm ${dest}
        fi
      fi
      action ln -s ${dir}/${src} ${dest}
    fi
  done

  popd > /dev/null
}

install_fonts()
{
  if command -v fc-cache @>/dev/null
  then
    echo -n "Refreshing Fonts, this may take some time..."
    action fc-cache -f
    echo " Done"
  else
    echo "fc-cache command not found, cannot load fonts"
  fi
}

run_vim_plugin_install()
{
  action vim +PluginInstall +qall
  echo "Don't forget to update/install tmux plugins"
}

compile_you_complete_me()
{
  if [[ -e "${HOME}/.vim/bundle/YouCompleteMe" ]]
  then
    # YouCompleteMe was installed, try to finish the installation steps
    if [[ "$(uname -o)" = "GNU/Linux" ]]
    then
      local build_flags="--clang-completer"

      if which apt-get > /dev/null
      then
        # Install dependencies using apt-get
        action sudo apt-get --assume-yes install build-essential cmake python-dev python3-dev
      elif which dnf > /dev/null
      then
        # Install dependencies using dnf
        action sudo dnf --assumeyes install automake gcc gcc-c++ kernel-devel cmake python-devel python3-devel
      elif which yum > /dev/null
      then
        # Install dependencies using yum
        action sudo yum --assumeyes install automake gcc gcc-c++ kernel-devel cmake python-devel python3-devel
      else
        echo "Unrecognized package manager, hopefully everythin we need is here..."
      fi

      if which node > /dev/null
      then
        # Javascript completion
        build_flags="${build_flags} --tern-completer"
      fi

      pushd ~/.vim/bundle/YouCompleteMe > /dev/null

      action ./install.py ${build_flags}

      popd > /dev/null
    else
      echo "Unknown/Unsupported OS, not building YouCompleteMe"
    fi
  fi
}

copy_minttyrc()
{
  if uname -r | grep 'Microsoft' > /dev/null
  then
    # WSL, copy over minttyrc
    local appdata=$(cmd.exe /c "echo %APPDATA%" 2>/dev/null | sed -e 's/^\([A-Z]\):/\/mnt\/\l\1/' -e 's/\\/\//g' -e 's/\r//g')

    if [[ -e ${appdata}/wsltty ]]
    then
      action cp ~/.minttyrc ${appdata}/wsltty/config
    else
      echo "Could not find wsltty config directory"
    fi
  fi
}

install_dotfiles()
{
  install_oh_my_zsh

  install_submodules

  install_vim_and_tmux_plugins

  backup_and_link_configs

  install_fonts

  compile_you_complete_me

  copy_minttyrc
}

uninstall_dotfiles()
{
  [[ ! -d ${olddir} ]] && echo "No backup, exitting" && exit 1

  for f in ${olddir}/*
  do
    orig=${HOME}/.${f##*/}
    [[ -e ${orig} ]] && action rm ${orig}
    action mv ${f} ${HOME}/.${f##*/}
  done
}

########
# MAIN #
########

$uninstall && uninstall_dotfiles || install_dotfiles
