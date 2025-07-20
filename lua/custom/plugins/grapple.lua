---@module 'lazy'
---@type LazySpec
return {
  'cbochs/grapple.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    scope = 'git', -- also try out "git_branch"
  },
  keys = {
    { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
    { '<C-a>', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },

    { '<A-1>', '<cmd>Grapple select index=1<cr>', desc = 'Select first tag' },
    { '<A-2>', '<cmd>Grapple select index=2<cr>', desc = 'Select second tag' },
    { '<A-3>', '<cmd>Grapple select index=3<cr>', desc = 'Select third tag' },
    { '<A-4>', '<cmd>Grapple select index=4<cr>', desc = 'Select fourth tag' },

    { '<A-h>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
    { '<A-l>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
  },
}
