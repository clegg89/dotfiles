" Required by Vim, ignored by NeoVim
set nocompatible

" Sense Vim/NeoVim
if has('nvim')
  let s:config_root = expand('~/.config/nvim')
  let s:data_root = expand('~/.local/share/nvim/site')
else
  let s:config_root = expand('~/.vim')
  let s:data_root = s:config_root
endif

" Install vim-plug if not installed
if empty(glob(s:data_root . '/autoload/plug.vim'))
  try
    execute mkdir(s:data_root . '/autoload', 'p')
  catch
  endtry
  execute '!curl -fLo ' . s:data_root . '/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change map leader to comma: ',' for easier leader mapping
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Ignore case when opening files
set wildignorecase

" Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Relative line numbers
set number
set relativenumber

" Unless we are jumping multiple lines, treat wrapped lines
" as multiple lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" A buffer becomes hidden when it is abandoned
set hid

" Configure other characters to move across lines
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Cursor config
function! SetupCursorConfig()
  " Whitelist supported terminals
  if &term =~ '^xterm\|^rxvt\|^screen\|^nvim'
    " let Wrapper = {args -> args}

    function! Passthrough(args)
      return a:args
    endfunc
    let Wrapper = function('Passthrough')

    if exists('$TMUX')
      " let Wrapper = {args -> '\<Esc>Ptmux;' . args . '\<Esc>\\'}
      function! TmuxWrap(args)
        return "\<Esc>Ptmux;" . a:args . "\<Esc>\\"
      endfunction
      let Wrapper = function('TmuxWrap')
    endif

    " 1 or 0 -> blinking block
    " 3 -> blinking underscore
    " Recent versions of xterm (282 or above) also support
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar

    " blinking vertical bar
    let &t_SI = Wrapper("\<Esc>[5 q")
    " solid block
    let &t_EI = Wrapper("\<Esc>[2 q")
    let &t_IS = Wrapper("\<Esc>[2 q")
    " blinking underscore
    if v:version > 704 || v:version == 704 && has('patch687')
      let &t_SR = Wrapper("\<Esc>[3 q")
    endif

    delfunction Passthrough

    if exists('TmuxWrap')
      delfunction TmuxWrap
    endif
  endif
endfunction

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

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn (helps with coc diagnostics
set signcolumn=yes

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Light backdrops are an abomination
set background=dark

" Load our colorscheme
try
  colorscheme obsidian
catch
endtry

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Always use unix fileformats
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Tag settings
set tags=./tags
if has('cscope')
  set cscopetag
  if filereadable("cscope.out")
    try
      cscope add cscope.out

      "Cscope mappings
      nmap s :cs find s =expand("<cword>")
      nmap g :cs find g =expand("<cword>")
      nmap c :cs find c =expand("<cword>")
      nmap t :cs find t =expand("<cword>")
      nmap e :cs find e =expand("<cword>")
      nmap f :cs find f =expand("<cfile>")
      nmap i :cs find i ^=expand("<cfile>")$
      nmap d :cs find d =expand("<cword>")
    catch
    endtry
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
  set undodir=s:data_root . '/undo'
  set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bash like keys for the command line
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

" Remove preview window
set completeopt-=preview

""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

""""""""""""""""""""""""""""""
" => Scheme section
"""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.sch set syntax=scheme

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(s:data_root . '/plugged')

Plug 'tpope/vim-obsession' " Session management
Plug 'vim-airline/vim-airline' " Airline status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'mileszs/ack.vim' " Search tool (grep)
Plug 'ctrlpvim/ctrlp.vim' " Find files
Plug 'scrooloose/nerdtree', { 'on' : 'NERDTreeToggle' } " File tree explorer
Plug 'wellle/targets.vim' " Additional objects (function arguments)
Plug 'terryma/vim-expand-region' " Visually select increasingly larger regions
Plug 'michaeljsmith/vim-indent-object' " Provides objects for indentations
Plug 'christoomey/vim-sort-motion' " Motions for sorting
Plug 'tpope/vim-surround' " delete, change, add 'surroundings' (quotes, brackets, etc.)
Plug 'tomtom/tlib_vim' " Utilities, needed by snipmate
Plug 'MarcWeber/vim-addon-mw-utils' " Utilities, needed by snipmate
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'airblade/vim-gitgutter' " Git diff gutter
Plug 'tpope/vim-obsession' " Continuosly update session files
Plug 'tmux-plugins/vim-tmux' " tmux.conf sytnax highlighting
Plug 'christoomey/vim-tmux-navigator' " Switch between tmux panes and vim panes seamlessly
Plug 'aperezdc/vim-template' " Filetype templates
Plug 'tpope/vim-commentary' " Toggle comments
Plug 'garbas/vim-snipmate' " Code snippets
Plug 'embear/vim-localvimrc' " Local configuration
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Code Completion
Plug 'puremourning/vimspector' " Debugging

call plug#end()

""""""""""""""""""""""""""""""
" => Vimspector
""""""""""""""""""""""""""""""
" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)

" for normal mode - the word under the cursor
nmap <leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <leader>di <Plug>VimspectorBalloonEval

""""""""""""""""""""""""""""""
" => CoC Completion
""""""""""""""""""""""""""""""
" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  " Returns true if we're at the beginning of a line or in front of backspace
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <tab> goes goes forward in selection
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
" <s-tab> goes backward in selection
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" <cr> selects an item
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Autocommand group pattern, see https://learnvimscriptthehardway.stevelosh.com/chapters/14.html
" basically prevents vim from redefining these commands repeatedly when reloading the source file
augroup cocgroup
  " Clear all previous group cmds
  autocmd!
  " Highlight the symbol and its references when holding the cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

map <leader>j :CtrlP<cr>
map <leader>o :CtrlPBuffer<cr>

""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
ino <c-j> <c-r>=snipMate#TriggerSnippet()<cr>
snor <c-j> <esc>i<right><c-r>=snipMate#TriggerSnippet()<cr>
let g:snipMate = { 'snippet_version' : 1 }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__', 'CVS', '\.o$']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_next_key='<C-s>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>

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

" Local extensions
if filereadable(expand("~/.local/etc/vimrc.vim"))
  source ~/.local/etc/vimrc.vim
endif

delfunction SetupCursorConfig

set exrc
set secure
