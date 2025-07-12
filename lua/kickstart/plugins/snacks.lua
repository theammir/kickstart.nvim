-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    -- snacks.nvim is a plugin that contains a collection of QoL improvements.
    -- One of those plugins is called snacks-picker
    -- It is a fuzzy finder, inspired by Telescope, that comes with a lot of different
    -- things that it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- Two important keymaps to use while in a picker are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Snacks picker. This is really useful to discover what snacks-picker can
    -- do as well as how to actually do it!

    -- [[ Configure Snacks Pickers ]]
    -- See `:help snacks-picker` and `:help snacks-picker-setup`
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
      picker = { enabled = true },
    },
    -- See `:help snacks-pickers-sources`
    keys = {
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Find Buffers',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Find Help',
      },
      {
        '<leader>fk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Find Keymaps',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.pickers()
        end,
        desc = 'Find Select Picker',
      },
      {
        '<leader>fw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Find Current Word',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Find by Grep',
      },
      {
        '<leader>fd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Find Diagnostics',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Find Resume',
      },
      {
        '<leader>f.',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Find Recent Files',
      },
      {
        '<leader>f/',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Find in Open Files',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Find in Current File',
      },
      {
        '<leader>fn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Find Neovim Files',
      },

      {
        '<leader>e',
        function()
          Snacks.picker.explorer()
        end,
      },

      {
        '<leader>g',
        function()
          Snacks.lazygit()
        end,
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
