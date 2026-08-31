return {
  'ptimoney/hledger-nvim',
  ft = { 'hledger', 'journal' },
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  opts = {
    keymap = '<localleader>lg',
    lsp_opts = {
      settings = {
        hledgerLanguageServer = {
          completion = {
            onlyDeclaredAccounts = false,
            onlyDeclaredPayees = false,
            onlyDeclaredCommodities = false,
            onlyDeclaredTags = false,
          },
          formatting = {
            decimalAlignColumn = 52,
          },
          inlayHints = {
            showRunningBalances = true,
          },
          validation = {
            undeclaredAccounts = false,
            requireExplicitCosts = true,
          },
        },
      },
    },
  },
}
