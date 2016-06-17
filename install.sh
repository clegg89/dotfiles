#!/bin/bash
###########################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
###########################

########## Variables

dir=${PWD##*/}          # dotfiles directory
olddir=${dir}_old   # old dotfiles backup directory

##########

# create dotfiles_old in homedir
mkdir -vp $olddir

for file in ./*; do
  src=${file##*/}
  dest=${HOME}/.$src
  script=${0##*/}
  if [ $src != $script ]
  then
    echo "Installing ${src} to ${dest}..."
    [[ -f $dest ]] && echo "Moving $dest to $olddir" #mv $dest $olddir
    echo "Linking ${dest} to ${dir}/${src}"
    #ln -s $dir/$file ~/.$file
    echo "done"
  fi
done
