""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>

""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>

""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

""""""""""""""""""""""""""""""
" => ZenCoding
""""""""""""""""""""""""""""""
" Enable all functions in all modes
let g:user_zen_mode='a'

""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
ino <c-j> <c-r>=snipMate#TriggerSnippet()<cr>
snor <c-j> <esc>i<right><c-r>=snipMate#TriggerSnippet()<cr>

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_next_key="\<C-s>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
let g:syntastic_auto_loc_list = 0

" Python
let g:syntastic_python_checkers=['pyflakes']

" Javascript
let g:syntastic_javascript_checkers = ['jshint']

" Go
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_theme='tomorrow'

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
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Templates
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Search Directories
let g:templates_directory = [ '~/.local/etc/vim-templates', '~/.vim/templates' ]
let g:templates_user_variables = [
  \   ['CUT_FILE', 'GetCutFile'],
  \   ['CUT_CLASS', 'GetCutClass' ],
  \   ['TEST_GROUP', 'TestGroup'],
  \   ['PERSONAL_CLASS', 'PersonalClass'],
  \   ['STRING_FROM_FILE', 'GetStringFromFile'],
  \   ['STRING_FROM_CLASS', 'GetStringFromClass'],
  \   ['COMPARATOR_FILE', 'GetComparatorFile'],
  \   ['COMPARATOR_CLASS', 'GetComparatorClass']
  \ ]

func! FileName()
  return expand("%:t:r:r:r")
endfunc

func! Classify(filen)
  return substitute(a:filen, "\\([a-zA-Z]\\+\\)", "\\u\\1\\e", "g")
endfunc

func! CamelCase(class)
  return substitute(a:class, "[_-]", "", "g")
endfunc

func! GetCutFile()
  let l:filen = FileName()
  return substitute(l:filen, "_test", "", "")
endfunc

func! GetCutClass()
  return CamelCase(Classify(GetCutFile()))
endfunc

func! TestGroup()
  return substitute(GetCutClass(), "\\([a-zA-Z]\\+\\)", "\\l\\1\\e", "g")
endfunc

func! PersonalClass()
  return CamelCase(Classify(FileName()))
endfunc

func! GetStringFromFile()
  let l:filen = FileName()
  return substitute(l:filen, "string-from-", "", "")
endfunc

func! GetStringFromClass()
  return CamelCase(Classify(GetStringFromFile()))
endfunc

func! GetComparatorFile()
  let l:filen = FileName()
  return substitute(l:filen, "-comparator", "", "")
endfunc

func! GetComparatorClass()
  return CamelCase(Classify(GetComparatorFile()))
endfunc
