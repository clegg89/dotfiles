return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { '<c-f>', '<cmd>Telescope find_files<cr>' },
      { '<c-p>', '<cmd>Telescope grep_string<cr>' },
    },
    config = function()
      require('telescope').setup()
    end,
  }
}
