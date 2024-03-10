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
install_whitelist="config/nvim tmux vim dircolors gdbinit gitconfig gitignore_global minttyrc tmux.conf vimrc Xresources Xdefaults zshenv zshrc urxvt/ext/font-size"

##########

install_oh_my_zsh()
{
  # The --unattended option prevents installing their .zshrc and also prevents their chsh command
  [[ -e "${HOME}/.oh-my-zsh" ]] || action curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended
}

install_submodules()
{
  pushd ${dir} > /dev/null

  action git submodule init
  action git submodule update

  popd > /dev/null
}

install_tmux_plugins()
{
  pushd ${dir} > /dev/null

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
  echo "Be sure to install powerline-fonts"
}

run_vim_plugin_install()
{
  # TODO med We switched plugin managers so fix this
  # [[ -x "$(command -v vim)" ]] && action vim +PlugInstall +qall
  # [[ -x "$(command -v nvim)" ]] && action nvim +PlugInstall +qall
  echo "Don't forget to update/install tmux plugins"
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

install_local_dirs()
{
  local dir_list="bin sbin include lib src etc share"

  install_dirs "${HOME}/.local" "${dir_list}"
}

install_dotfiles()
{
  install_oh_my_zsh

  install_submodules

  install_tmux_plugins

  backup_and_link_configs

  install_fonts

  run_vim_plugin_install

  copy_minttyrc

  install_local_dirs
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
