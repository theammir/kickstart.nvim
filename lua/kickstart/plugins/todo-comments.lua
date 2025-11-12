-- Highlight todo, notes, etc in comments
---@module 'lazy'
---@type LazySpec
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ---@module 'todo-comments'
  ---@type TodoOptions
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    signs = false,
    keywords = {
      NOTE = {
        alt = { 'INFO', 'SAFETY' },
      },
    },
    highlight = {
      pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
    },
    search = {
      -- manually exclude SAFETY from search results
      -- Snacks.picker.todo_comments compatible
      pattern = [[\b(PERFORMANCE|OPTIMIZE|TESTING|WARNING|PASSED|FAILED|OPTIM|ISSUE|FIXIT|FIXME|PERF|NOTE|WARN|HACK|TODO|TEST|INFO|XXX|FIX|BUG)\s*(\([^\)]*\))?:]],
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
