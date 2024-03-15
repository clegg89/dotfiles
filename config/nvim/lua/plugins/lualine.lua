return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'powerline_dark',
        extensions = { 'lazy','mason','neo-tree' }
      }
    }
  }
}
