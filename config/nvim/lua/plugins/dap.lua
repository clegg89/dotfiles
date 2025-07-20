return {
  'mfussenegger/nvim-dap',
  {
    'jay-babu/mason-nvim-dap.nvim',
    opts = {
      ensure_installed = { 'cortex-debug' }
    },
  },
  { "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    opts = {
      libraries = { "nvim-dap-ui" },
      -- layouts = {
      --   {
      --     position = 'left',
      --     size = 96,
      --     elements = {
      --       { id = 'scopes', size = 0.4 },
      --       { id = 'rtt', size = 0.6 },
      --     },
      --   },
      -- },
    },
  },
  {
    'jedrzejboczar/nvim-dap-cortex-debug',
    dependencies = {'mfussenegger/nvim-dap'},
    opts = {
      debug = false,  -- log debug messages
      -- path to cortex-debug extension, supports vim.fn.glob
      -- by default tries to guess: mason.nvim or VSCode extensions
      extension_path = nil,
      lib_extension = nil, -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
      node_path = 'node', -- path to node.js executable
      dapui_rtt = true, -- register nvim-dap-ui RTT element
      -- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
      dap_vscode_filetypes = { 'c', 'cpp' },
      rtt = {
          buftype = 'Terminal', -- 'Terminal' or 'BufTerminal' for terminal buffer vs normal buffer
      },
    },
  },
}
