source ~/.vim/vimrcs/basic.vim
source ~/.vim/vimrcs/filetypes.vim
source ~/.vim/vimrcs/plugin_config.vim
source ~/.vim/vimrcs/extended.vim

" Local extensions
if filereadable("~/.local/etc/vimrc.vim")
  source ~/.local/etc/vimrc.vim
endif
