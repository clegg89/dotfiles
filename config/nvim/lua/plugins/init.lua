return {
  'tpope/vim-obsession', -- Session management => auto-session
  'tmux-plugins/vim-tmux', -- tmux.conf sytnax highlighting KEEP
  'wellle/targets.vim', -- Additional objects (function arguments) KEEP
  {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  },
  -- gitsigns.nvim
  'tpope/vim-fugitive', -- Git wrapper
  'airblade/vim-gitgutter', -- Git diff gutter
  'aperezdc/vim-template', -- Filetype templates => esqueleto.nvim
  {
      'numToStr/Comment.nvim',
      opts = {
          -- add any options here
      },
      lazy = false,
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  'embear/vim-localvimrc', -- Local configuration => nvim-config-local
  {
    'aserowy/tmux.nvim', -- tmux integration
    config = function()
      require('tmux').setup()
    end
  },
  'mfussenegger/nvim-dap', -- Debugging
}

