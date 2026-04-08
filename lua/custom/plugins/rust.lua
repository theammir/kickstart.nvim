---@module 'lazy'
---@type LazySpec
return {
  {
    'mrcjkb/rustaceanvim',
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= 'rust-analyzer' then
            return
          end

          vim.keymap.set('n', '<localleader>la', function() vim.cmd.RustLsp { 'codeAction' } end, { desc = 'rust-analyzer code actions' })
          vim.keymap.set('n', '<localleader>lc', '<cmd>RustLsp openCargo<cr>', { desc = 'Open current Cargo.toml' })
          vim.keymap.set('n', '<localleader>ld', '<cmd>RustLsp openDocs<cr>', { desc = 'View symbol at docs.rs' })
          vim.keymap.set('n', '<localleader>lD', '<cmd>Cargo doc --no-deps --document-private-items<cr>', { desc = 'Build local documentation' })
          vim.keymap.set('n', '<localleader>le', '<cmd>RustLsp explainError current<cr>', { desc = 'Explain error on this line' })
          vim.keymap.set('n', '<localleader>lE', '<cmd>RustLsp expandMacro<cr>', { desc = 'Expand Rust macro' })
          vim.keymap.set('n', '<localleader>lj', '<cmd>RustLsp relatedDiagnostics<cr>', { desc = 'Jump to related diagnostics' })
          vim.keymap.set('n', '<localleader>lr', '<cmd>RustLsp runnables<cr>', { desc = 'View current runnables' })
          vim.keymap.set('n', '<localleader>lt', '<cmd>RustTest<cr>', { desc = 'Run test under cursor' })

          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { silent = true, buffer = args.buf })
        end,
      })
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
            },
          },
        },
      }
    end,
  },
}
