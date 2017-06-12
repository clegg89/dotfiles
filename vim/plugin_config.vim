"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clang Complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Select first entry in popup
let g:clang_auto_select = 1
let g:clang_snippets_engine = 1
let g:clang_complete_macros = 1
let g:clang_complete_option_args_in_snippets = 1
let g:clang_trailing_placeholder = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
