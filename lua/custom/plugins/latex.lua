---@module 'lazy'
---@type LazySpec
return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      out_dir = 'build',
      callback = 1,
      continuous = 1,
      executable = 'latexmk',
      options = {
        '-verbose',
        '-file-line-error',
        '-interaction=nonstopmode',
        '-synctex=1',
        '-shell-escape',
      },
    }

    vim.g.vimtex_fold_enabled = 1
  end,
}
