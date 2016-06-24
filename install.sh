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

install_dotfiles()
{
  # Make sure submodules are present
  pushd ${dir} > /dev/null
  git submodule init
  git submodule update
  popd > /dev/null

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

  if command -v fc-cache @>/dev/null
  then
    echo -n "Refreshing Fonts (this may take some time...)"
    fc-cache -f
    echo " Done"
  else
    echo "fc-cache command not found, cannot load fonts"
  fi

  echo "Make sure to install VIM and TMUX plugins using respective package managers"
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
