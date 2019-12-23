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
install_blacklist="Desktop Downloads Templates Public Documents Music Pictures Videos"
install_whitelist="fonts config/user-dirs.defaults config/nvim tmux vim bash_profile bashrc dircolors gdbinit gitconfig gitignore_global inputrc minttyrc tmux.conf vimrc Xresources Xdefaults zshenv zshrc urxvt/ext/font-size"

##########

install_oh_my_zsh()
{
  local ZSH="${HOME}/.oh-my-zsh"

  # The install script launches a zsh shell and does other unnecessary stuff. Just run the git command
  # action 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'

  [[ -e "${ZSH}" ]] || action git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ${ZSH}
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
  [[ -e "vim/bundle" ]] && action rm -rf vim/bundle
  [[ -e "tmux/plugins/tpm" ]] || action git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm

  popd > /dev/null
}

make_intermediate_dir()
{
  local intermediate=${1%/*}
  local intermediate=${intermediate##*/.}

  action mkdir -p ${olddir}/${intermediate##.}
}

backup_file()
{
  local file=$1

  # Remove symbolic links, move actual files
  if [[ -L $file ]]; then
    action rm ${file}
  else

    make_intermediate_dir ${file}

    action mv ${file} ${olddir}/${file##*/.}
  fi
}

backup_if_exists()
{
  local file=$1

  [[ -e $file ]] && backup_file $file
}

backup_and_link_configs()
{
  # create dotfiles_old in homedir
  [[ -e ${olddir} ]] && rm -rf ${olddir}
  action mkdir -p ${olddir}

  for file in ${install_whitelist}; do
    local src=${file##*/}
    local intermediate=${file%/*}

    if [[ ${intermediate} != ${src} ]]; then
      local dest=${HOME}/.${intermediate}/${src}
      action mkdir -p ${HOME}/.${intermediate}
    else
      local dest=${HOME}/.${src}
    fi

    backup_if_exists ${dest}

    action ln -s ${dir}/${file} ${dest}
  done
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
  action vim +PlugInstall +qall
  action nvim +PlugInstall +qall
  echo "Don't forget to update/install tmux plugins"
}

install_ycm_dependencies()
{
  if which apt-get > /dev/null
  then
    # Install dependencies using apt-get
    action sudo apt-get --assume-yes install build-essential cmake python3-dev
  elif which dnf > /dev/null
  then
    # Install dependencies using dnf
    action sudo dnf --assumeyes install automake gcc gcc-c++ kernel-devel cmake python3-devel
  elif which yum > /dev/null
  then
    # Install dependencies using yum
    action sudo yum --assumeyes install automake gcc gcc-c++ kernel-devel cmake python3-devel
  else
    echo "Unrecognized package manager, hopefully everything we need is here..."
  fi
}

determine_ycm_build_flags()
{
  local build_flags="--clang-completer"

  if which node > /dev/null; then
    # Javascript completion
    build_flags="${build_flags} --tern-completer"
  fi

  echo ${build_flags}
}

run_ycm_install()
{
  local build_flags=$(determine_ycm_build_flags)

  pushd ~/.vim/plugged/YouCompleteMe > /dev/null

  action ./install.py ${build_flags}

  popd > /dev/null

  pushd ~/.local/share/nvim/site/plugged/YouCompleteMe > /dev/null

  action ./install.sh ${build_flags}

  popd > /dev/null
}

compile_you_complete_me()
{
  if [[ -e "${HOME}/.vim/plugged/YouCompleteMe" ]]
  then
    # YouCompleteMe was installed, try to finish the installation steps
    if [[ "$(uname -o)" = "GNU/Linux" ]]
    then
      install_ycm_dependencies

      run_ycm_install
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
      action install --mode=755 ~/.minttyrc ${appdata}/wsltty/config
    else
      echo "Could not find wsltty config directory"
    fi
  fi
}

install_dirs()
{
  local root_dir=$1
  local dir_list=$2

  [[ -d ${rood_dir} ]] || install --directory --mode=755 ${root_dir}

  for dir in ${dir_list}; do
    action install --directory --mode=755 ${root_dir}/${dir}
  done
}

install_home_dirs()
{
  local dir_list="devel documents downloads explore build"

  install_dirs "${HOME}" "${dir_list}"
}

install_local_dirs()
{
  local dir_list="bin sbin include lib src etc share"

  install_dirs "${HOME}/.local" "${dir_list}"
}

install_xdg_dirs()
{
  if which xdg-user-dirs-update > /dev/null; then
    action xdg-user-dirs-update
  fi
}

clean_home_dir()
{
  for file in ${install_blacklist}; do
    # Do not force remove. If the directory is empty we want to leave it
    backup_if_exists ${HOME}/${file}
  done
}

install_dotfiles()
{
  install_oh_my_zsh

  install_submodules

  install_vim_and_tmux_plugins

  backup_and_link_configs

  install_fonts

  run_vim_plugin_install

  compile_you_complete_me

  copy_minttyrc

  install_home_dirs

  install_local_dirs

  install_xdg_dirs

  clean_home_dir
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

if $uninstall; then
  uninstall_dotfiles
else
  install_dotfiles
fi
