return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered()
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          -- ['<Tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   elseif luasnip.expand_or_jumpable() then
          --     luasnip.expand_or_jump()
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 's' }),
          -- ['<S-Tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- cmp.setup.filetype('gitcommit', {
      --   sources = cmp.config.sources({
      --     { name = 'git' },
      --   }, {
      --     { name = 'buffer' },
      --   })
      -- })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'mason-org/mason.nvim', 'jay-babu/mason-nvim-dap.nvim', 'williamboman/mason-lspconfig.nvim' },
    config = function()
      vim.lsp.config('clangd', {
        cmd = {
          "clangd",
          "--query-driver='/usr/bin/arm-none-eabi*"
        }
      })

      vim.lsp.enable('lua_ls')
      vim.lsp.enable('clangd')
      vim.lsp.enable('cmake')
      vim.lsp.enable('pyright')
      -- TODO docker-compose, dockerls, LaTeX, Markdown, NGinx

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
          end

          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('so', require('telescope.builtin').lsp_references, 'Telescope Symbols')

          local dap = require('dap')
          map('<leader>dt', dap.toggle_breakpoint, 'Toggle Break')
          map('<leader>dc', dap.continue, 'Continue')
          map('<leader>dr', dap.repl.open, 'Inspect')
          map('<leader>dk', dap.terminate, 'Kill')

          map('<leader>dso', dap.step_over, 'Step Over')
          map('<leader>dsi', dap.step_into, 'Step Into')
          map('<leader>dsu', dap.step_out, 'Step Out')
          map('<leader>dl', dap.run_last, 'Run Last')

          local dapui = require('dapui')
          map('<leader>duu', dapui.open, 'open ui')
          map('<leader>duc', dapui.close, 'open ui')
        end,
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      -- We pretty much use the following universally so make sure they're always installed
      ensure_installed = { 'lua_ls', 'clangd', 'cmake', 'pyright' }
    },
  },
  -- {
  --   'tamago324/nlsp-settings.nvim',
  --   dependencies = {
  --     'neovim/nvim-lspconfig',
  --   },
  --   confg = function()
  --     require('nlspsettings').setup({
  --       config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  --       local_settings_dir = '.nlsp-settings',
  --       local_settings_root_markers_fallback = { '.git' },
  --       append_default_schemas = true,
  --       loader = 'json'
  --     })
  --   end,
  -- },
}
