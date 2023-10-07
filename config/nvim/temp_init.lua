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
vim.keymap.set("n", "j (v:count == 0 ? 'gj' : 'j')",
  { noremap = true, silent = true, expr = true })
vim.keymap.set("n", "k (v:count == 0 ? 'gk' : 'k')",
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

