-- Highlight todo, notes, etc in comments
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
    keywords = {
      NOTE = {
        alt = { 'INFO', 'SAFETY' },
      },
    },
    search = {
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--pcre2',
      },
      pattern = [[\b(?!(?:SAFETY\b))(KEYWORDS):]],
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
