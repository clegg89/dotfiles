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
vim.keymap.set("n", "j" "(v:count == 0 ? 'gj' : 'j')",
  { noremap = true, silent = true, expr = true })
vim.keymap.set("n", "k" "(v:count == 0 ? 'gk' : 'k')",
  { noremap = true, silent = true, expr = true })

