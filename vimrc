source ~/.vim/vimrcs/basic.vim
source ~/.vim/vimrcs/filetypes.vim
source ~/.vim/vimrcs/plugin_config.vim
source ~/.vim/vimrcs/extended.vim

" Local extensions
if filereadable(expand("~/.local/etc/vimrc.vim"))
  source ~/.local/etc/vimrc.vim
endif
