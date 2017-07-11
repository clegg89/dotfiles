Plug 'vim-scripts/bufexplorer.zip', { 'on': 'BufExplorer' } " Visually show and select buffers

if has("win32unix")
  " Cygwin (win32unix) doesn't work well with YouCompleteMe
  Plug 'Rip-Rip/clang_complete', { 'for': ['cpp', 'c'] }
elseif has("unix")
  Plug 'Valloric/YouCompleteMe'
  Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
endif
