return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { '<c-f>', '<cmd>Telescope find_files<cr>' },
      { '<c-p>', '<cmd>Telescope live_grep<cr>' },
    },
    opts = {}
  }
}
