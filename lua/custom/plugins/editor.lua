---@module 'lazy'
---@type LazySpec
return {
  'tpope/vim-repeat',
  'airblade/vim-rooter',
  'sitiom/nvim-numbertoggle',
  {
    'declancm/maximize.nvim',
    opts = {},
    keys = { {
      '<F3>',
      function() require('maximize').toggle() end,
      desc = 'Maximize split toggle',
    } },
  },
  {
    'ggandor/leap.nvim',
    lazy = false,
    config = function()
      local leap = require 'leap'
      leap.create_default_mappings()

      leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
      -- require('leap.user').set_repeat_keys('<enter>', '<backspace>')

      vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
        callback = function()
          leap.init_highlight(true)
          vim.api.nvim_set_hl(0, 'LeapLabel', {
            -- For light themes, set to 'black' or similar.
            fg = 'red',
          })
        end,
      })
    end,
  },
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    opts = {
      mappings = {
        t = { j = { false } }, -- lazygit navigation fix
        v = { j = { false } }, -- visual select fix
      },
    },
  },
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {},
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      require('ufo').setup()

      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    opts = {
      size = 10,
      open_mapping = [[<F7>]],
      shading_factor = 2,
      direction = 'float',
      float_opts = {
        border = 'curved',
        highlights = { border = 'Normal', background = 'Normal' },
      },
    },
  },
  {
    'filipdutescu/renamer.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {},
  },
  {
    'mikavilpas/yazi.nvim',
    cond = vim.fn.executable 'yazi' == 1,
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
      {
        '<leader>y',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },
}
