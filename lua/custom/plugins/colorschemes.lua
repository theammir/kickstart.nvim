---@module 'lazy'
---@type LazySpec
return {
  {
    'zaldih/themery.nvim',
    opts = {
      themes = {
        'nord',
        'carbonfox',
        'catppuccin',
        'catppuccin-frappe',
        'catppuccin-macchiato',
        'catppuccin-mocha',
        'duskfox',
        'kanagawa',
        'kanagawa-dragon',
        'kanagawa-wave',
        'nightfox',
        'nord',
        'nordfox',
        'onenord',
        'terafox',
        'tokyonight',
        'tokyonight-moon',
        'tokyonight-night',
        'tokyonight-storm',
      },
      livePreview = true,
    },
  },
  {
    'shaunsingh/nord.nvim',
    priority = 1000,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin.nvim',
    priority = 1000,
    opts = {
      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.lavender },
          BlinkCmpMenuBorder = { fg = colors.lavender },
        }
      end,
      transparent_background = not vim.g.neovide,
      float = {
        transparent = not vim.g.neovide,
        solid = vim.g.neovide,
      },
      integrations = {
        blink_cmp = {
          style = 'bordered',
        },
        fidget = true,
        gitsigns = {
          enabled = true,
          transparent = not vim.g.neovide,
        },
        leap = false,
        mason = true,
        mini = {
          enabled = true,
          indent_scope_color = 'lavender',
        },
        nvim_surround = false,
        ufo = true,
        render_markdown = true,
        snacks = {
          enabled = true,
          indent_scope_color = 'lavender',
        },
        which_key = true,
      },
    },
  },
  {
    'rmehri01/onenord.nvim',
    priority = 1000,
  },
  {
    'navarasu/onedark.nvim',
    priority = 1000,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
  },
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
  },
}
