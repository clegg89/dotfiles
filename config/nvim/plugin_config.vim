""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
map <leader>j :CtrlP<cr>
map <leader>o :CtrlPBuffer<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_server_python_interpreter = '/usr/bin/python2'
" Have to copy defaults because we can't append. We've added ruby
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1,
      \ 'ruby' : 1
      \}
let g:ycm_key_invoke_completion = '<C-g>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => SnipMate
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:snipMate = { 'snippet_version' : 1 }

