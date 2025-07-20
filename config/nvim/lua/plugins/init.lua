return {
  {
    -- Show current keybindings
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- 'tpope/vim-obsession', -- Session management => auto-session
  -- 'tmux-plugins/vim-tmux', -- tmux.conf sytnax highlighting KEEP
  -- 'wellle/targets.vim', -- Additional objects (function arguments)
  -- {
  --     "kylechui/nvim-surround",
  --     version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --     event = "VeryLazy",
  --     config = function()
  --         require("nvim-surround").setup({
  --             -- Configuration here, or leave empty to use defaults
  --         })
  --     end
  -- },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  -- 'aperezdc/vim-template', -- Filetype templates => esqueleto.nvim
  -- ----  {
  --     'numToStr/Comment.nvim',
  --     opts = {
  --         -- add any options here
  --     },
  --     lazy = false,
  -- },
  {
    'klen/nvim-config-local',
    config = function()
      require('config-local').setup()
    end
  },
  {
    'aserowy/tmux.nvim', -- tmux integration
    config = function()
      require('tmux').setup()
    end
  },
  {
    'mason-org/mason.nvim',
    opts = {}
  },
}

