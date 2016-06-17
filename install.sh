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

dir=${PWD}                         # dotfiles directory
olddir=${dir}_old   # old dotfiles backup directory
script=${0##*/}                   # Script name

##########

install_dotfiles()
{
  # create dotfiles_old in homedir
  action mkdir -p ${olddir}

  for file in ./*; do
    src=${file##*/}
    dest=${HOME}/.${src}
    script=${0##*/}
    if [ ${src} != ${script} ]
    then
      [[ -e $dest ]] && action mv ${dest} ${olddir}/${dest##*/.}
      action ln -s ${dir}/${src} ${dest}
    fi
  done
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

# Hidden files will not be included if dotglob option is unset
# Query the current value
# shopt -q dotglob
# dotstatus=$?

# Set if it wasn't set
# (( "$dotstatus" )) && shopt -s dotglob

$uninstall && uninstall_dotfiles || install_dotfiles

# Clear if it wasn't set
# (( "$dotstatus" )) || shopt -u dotglob