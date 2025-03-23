return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  branch = 'v0.6',
  config = function()
    local ua = require 'ultimate-autopair'
    local prev = function(o)
      return o.line:sub(o.col - 1, o.col - 1)
    end
    ua.init {
      ua.extend_default {
        fastwarp = {
          enable = true,
        },
        config_internal_pairs = {
          {
            "'",
            "'",
            cond = function(fn, o)
              return prev(o) == '' or prev(o):match '[^&<\\]'
            end,
            suround = true,
            nft = { 'tex' },
            alpha = true,
            multiline = false,
          },
        },
        {
          '<',
          '>',
          cond = function(fn, o)
            return prev(o) == '' or prev(o):match '[^%s<\\]'
          end,
          dosuround = true,
          space = true,
          multiline = false,
        },
        {
          '$',
          '$',
          fly = true,
          dosuround = true,
          space = true,
          ft = { 'tex' },
        },
        {
          '$$',
          '$$',
          fly = true,
          dosuround = true,
          space = true,
          ft = { 'tex' },
        },
        { '\\[', '\\]', fly = false, ft = { 'tex' }, newline = true },
      },
    }
  end,
}
