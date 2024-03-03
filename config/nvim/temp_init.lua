-- Bootstrap plugin manager (vim-plug, lazy.nvim?)

---------------------------------------------------------------
-- General
---------------------------------------------------------------
-- Change map leader to comma: ',' for easier leader mapping
vim.g.mapleader = ","

-- Fast saving
vim.keymap.set("n", "<leader>w", ":w!<cr>")

---------------------------------------------------------------
-- VIM user interface
---------------------------------------------------------------
-- Set 7 lines to the cursor - when moving vertically using j/k
vim.o.so = 7

-- Ignore compiled files, and version control
vim.opt.wildignore = {
    "*.o", "*~", "*.pyc",
    ".git/*", ".hg/*", ".svn/*"
}

-- Ignore case when opening files
vim.o.wildignorecase = true

-- Always show current position
vim.o.ruler = true

-- Height of the command bar
vim.o.cmdheight = 2

-- Relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Unless we are jumping multiple lines, treat wrapped lines
-- as multiple lines
local function wrap_movement(map)
  return function ()
    return (vim.v.count == 0 and 'g' .. map or map)
  end
end

vim.keymap.set("n", "j", wrap_movement('j'),
  { noremap = true, silent = true, expr = true })
vim.keymap.set("n", "k", wrap_movement('k'),
  { noremap = true, silent = true, expr = true })

-- A buffer becomes hidden when it is abandoned
vim.o.hid = true

-- Configure other characters to move across lines
for opt in {'<','>','h','l'} do table.insert(vim.opt.whichwrap, opt) end

-- Ignore case when searching
vim.o.ignorecase = true

-- When wearching try to be smart about case
vim.o.smartcase = true

-- Make search act like search in moder browsers
vim.o.incsearch = true

-- Don't redraw while executing macros (good performance config)
vim.o.lazyredraw = true

-- For regular expressions turn magic on
vim.o.magic = true

-- Show matching brackets when text indicator is over them
vim.o.showmatch = true
-- How many tenths of a second to blink when matching brackets
vim.o.mat = 2

-- No annoying sound on errors
vim.o.noerrorbells = true
vim.o.novisualbell = true
vim.o.tm = 500

-- Add a bit extra margin to the left
vim.o.foldcolumn = 1

-- Setup cursor
-- This was previously a lot more complicated, but we're just going
-- to assume we're on neovim >= 0.2.0 at this point and use guicursor
vim.o.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticable
-- delays and poor user experience
vim.o.updatetime = 300

-- Always show the signcolumn (helps with coc diagnostics)
vim.o.signcolumn = "yes"

---------------------------------------------------------------
-- Colors and Fonts
---------------------------------------------------------------
-- Load our colorscheme
vim.cmd [[colorscheme obsidian]]

-- Always use unix fileformats
vim.opt.ffs = { 'unix', 'dos', 'mac' }

---------------------------------------------------------------
-- Files, backups and undo
---------------------------------------------------------------
-- Turn backup off, since most stuff is in SVN, git et.c anyway...
vim.o.nobackup = true
vim.o.nowb = true
vim.o.noswapfile = true

---------------------------------------------------------------
-- Text, tab and indent related
---------------------------------------------------------------
-- Use spaces instead of tabs
vim.o.expandtab = true

-- 1 tab == 2 spaces
vim.o.shiftwidth=2
vim.o.tabstop=2

-- Linebreak on 500 characters
vim.o.lbr = true
vim.o.tw=500

vim.o.ai = true --Auto indent
vim.o.si = true --Smart indent
vim.o.wrap = true --Wrap lines

------------------------------
-- Visual mode related
------------------------------
-- Visual mode pressing * or # searches for the current selection
-- Super useful! From an idea by Michael Naumann
-- TODO I don't really use this feature but it would be cool to have
-- it's going to take some work to migrate it from vimscript to lua
-- and I don't want to do that right now. Here's the full vim code
--
-- function! VisualSelection(direction, extra_filter) range
--     let l:saved_reg = @" " Assuming this saves off the anonymous register
--     execute "normal! vgvy" " Not sure what this is doing
-- 
--     let l:pattern = escape(@", '\\/.*$^~[]') " Weird regex voodoo
--     let l:pattern = substitute(l:pattern, "\n$", "", "") " Guessing get rid of newlines?
-- 
--     if a:direction == 'gv'
--         call CmdLine("Ag \"" . l:pattern . "\" " )
--     elseif a:direction == 'replace'
--         call CmdLine("%s" . '/'. l:pattern . '/')
--     endif
-- 
--     " Restore registers?
--     let @/ = l:pattern
--     let @" = l:saved_reg
-- endfunction
--
-- vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
-- vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

---------------------------------------------------------------
-- Moving around, tabs, windows and buffers
---------------------------------------------------------------
-- Map <Space> to / (search). Not using ctrl-space as it's the tmux prefix
vim.keymap.set('', '<space>', '/')

-- Disable highlight when <leader><cr> is pressed
vim.keymap.set('', '<leader><cr>', ':noh<cr>', { silent = true })

-- Close the current buffer
local function bufClose()
  -- Don't close window when deleting a buffer
  local currentBuf = vim.api.nvim_get_current_buf()
  local altBuf = vim.fn.bufnr('#')

  if vim.api.nvim_buf_is_loaded(altBuf) then
    vim.api.nvim_set_current_buf(altBuf)
  else
    vim.cmd.bnext()
  end

  if vim.api.nvim_get_current_buf() == currentBuf then
    vim.cmd.new()
  end

  if vim.api.nvim_buf_is_loaded(currentBuf) then
    vim.cmd(string.format('bdelete! %d', currentBuf))
  end

  vim.cmd.tabclose()
  vim.cmd.tabp()
end
vim.keymap.set('', '<leader>bd', bufClose)

-- vim.keymap.set('', '<leader>bd'

-- Close all the buffers
vim.keymap.set('', '<leader>ba', ':bufdo bd<cr>')

-- Move around buffers
vim.keymap.set('', '<leader>l', ':bnext<cr>')
vim.keymap.set('', '<leader>h', ':bprevious<cr>')

-- Useful mappings for managing tabs
vim.keymap.set('', '<leader>tn', ':tabnew<cr>')
vim.keymap.set('', '<leader>to', ':tabonly<cr>')
vim.keymap.set('', '<leader>tc', ':tabclose<cr>')
vim.keymap.set('', '<leader>tm', ':tabmove<cr>')
vim.keymap.set('', '<leader>t<leader>', ':tabnext<cr>')

-- Let 'tl' toggle between this and the last accessed tab
vim.g.lasttab = 1
vim.keymap.set('n', '<leader>tl', function () vim.cmd.tabnext(vim.g.lasttab) end)
vim.api.nvim_create_autocmd('TabLeave', {
  pattern = '*',
  callback = function () vim.g.lasttab = vim.cmd.tabpagenr() end
})

-- Opens a new tab with the current buffer's path
-- Super useful when editing files in the same directory
vim.keymap.set('', '<leader>te', '<c-r>=expand("%:p:h")<cr>/')

-- Switch CWD to the directory of the open buffer
vim.keymap.set('', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>')

-- Specify the behavior when switching between buffers
vim.opt.switchbuf = { 'useopen', 'usetab', 'newtab' }
vim.o.stal = 2

-- Return to the last edit position when opening files (You want this!)
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
})

------------------------------
-- Status line
------------------------------
-- Always show the status line
vim.o.laststatus = 2

---------------------------------------------------------------
-- Editing mappings
---------------------------------------------------------------
-- Remap VIM 0 to first non-blank character
vim.keymap.set('', '0', '^')

-- Move a line of text using ALT+[jk] or Command+[jk] on mac
vim.keymap.set("n", "<M-j>", "mz:m+<cr>`z")
vim.keymap.set("n", "<M-k>", "mz:m-2<cr>`z")
vim.keymap.set("v", "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
vim.keymap.set("v", "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")

-- Delete trailing white space on save, useful for Python and CoffeeScript ;)
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//ge]],
})

---------------------------------------------------------------
-- Misc
---------------------------------------------------------------
-- Remove the Windows ^M - when the encodings gets messed up
vim.keymap.set('', '<leader>m', "mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm",
  { noremap = true })

-- Quickly open a buffer for scribble
vim.keymap.set('', '<leader>q', ':e ~/buffer<cr>')

-- Quickly open a markdown buffer for scribble
vim.keymap.set('', '<leader>x', ':e ~/buffer.md<cr>')

-- Toggle paste mode on and off
vim.keymap.set('', '<leader>pp', ':setlocal paste!<cr>')

---------------------------------------------------------------
-- Turn persistent undo on
--   means that you can undo even when you close a buffer/VIM
---------------------------------------------------------------
vim.opt.undodir = { 's:data_root', '.', '/undo' }
vim.o.undofile = true

---------------------------------------------------------------
-- Command mode related
---------------------------------------------------------------
-- Bash like keys for the command line
vim.keymap.set('c', '<C-A>', '<Home>', { noremap = true })
vim.keymap.set('c', '<C-E>', '<End>', { noremap = true })
vim.keymap.set('c', '<C-K>', '<C-U>', { noremap = true })
vim.keymap.set('c', '<C-P>', '<Up>', { noremap = true })
vim.keymap.set('c', '<C-N>', '<Down>', { noremap = true })

