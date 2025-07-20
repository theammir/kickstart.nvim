---@module 'lazy'
---@type LazySpec
return {
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          vim.keymap.set('n', '<localleader>lc', '<cmd>RustLsp openCargo<cr>', { desc = 'Open current Cargo.toml' })
          vim.keymap.set('n', '<localleader>ld', '<cmd>RustLsp openDocs<cr>', { desc = 'View symbol at docs.rs' })
          vim.keymap.set('n', '<localleader>le', '<cmd>RustLsp explainError current<cr>', { desc = 'Explain error on this line' })
          vim.keymap.set('n', '<localleader>lE', '<cmd>RustLsp expandMacro<cr>', { desc = 'Expand Rust macro' })
          vim.keymap.set('n', '<localleader>lr', '<cmd>RustLsp runnables<cr>', { desc = 'View current runnables' })
          vim.keymap.set('n', '<localleader>lt', '<cmd>RustTest<cr>', { desc = 'Run test under cursor' })

          local bufnr = vim.api.nvim_get_current_buf()
          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { silent = true, buffer = bufnr })
        end,
      })
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = true,
              },
              check = {
                command = 'clippy',
              },
              imports = {
                granularity = {
                  group = 'crate',
                },
              },
            },
          },
        },
      }
    end,
  },
}
