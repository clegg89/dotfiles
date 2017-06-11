if has("win32unix")
  " Cygwin (win32unix) doesn't work well with YouCompleteMe
  Plugin 'Rip-Rip/clang_complete'
elseif has("unix")
  Plugin 'Valloric/YouCompleteMe'
endif
