inoremap <silent> <expr> <Tab> config#tabComplete()

function! g:config#tabComplete() abort
  let l:col = col('.') - 1

  if pumvisible()
    return "\<C-n>"
  else
    if !l:col || getline('.')[l:col - 1] !~# '\k'
      return "\<TAB>"
    else
      return "\<C-n>"
    endif
  endif
endfunction

" Ignore case when opening files
set wildignorecase

function! s:GetNvimVersion()
  redir => l:version
  silent! version
  redir END
  " \zs with set the start of the match at that location.
  " version will output 'NVIM v0.2.0', so the regex will
  " match starting after the 'v' and matches anything until
  " a new line
  "
  " See :h /\zs
  return matchstr(l:version, 'NVIM v\zs[^\n]*')
endfunction

" Cursor config
if &term =~ '^xterm\|^rxvt\|^screen\|^nvim'
  if &term =~ '^nvim'
    if s:GetNvimVersion() < '0.2.0'
      " Older versions of nvim behave similar to vim
      let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

      call SetupCursorConfig()
    else
      let &guicursor='n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'
    endif
  endif
endif
