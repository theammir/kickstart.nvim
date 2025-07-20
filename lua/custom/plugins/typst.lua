---@module 'lazy'
---@type LazySpec
return {
  'chomosuke/typst-preview.nvim',
  lazy = false,
  opts = {
    dependencies_bin = { ['tinymist'] = 'tinymist' },
  },
}
