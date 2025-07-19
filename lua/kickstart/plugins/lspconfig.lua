return {
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },

      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end

          local deprecated = function(key, func)
            return function()
              vim.print('Use `' .. key .. '` instead, dumbass.')
              func {}
            end
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', deprecated('grd', Snacks.picker.lsp_definitions), 'Goto Definition')
          map('grd', Snacks.picker.lsp_definitions, 'Goto Definition')

          -- Find references for the word under your cursor.
          map('grr', Snacks.picker.lsp_references, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', Snacks.picker.lsp_implementations, 'Goto Implementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', Snacks.picker.lsp_type_definitions, 'Type Definition')

          map('<leader>ld', vim.diagnostic.open_float, 'Open diagnostic in float')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ls', deprecated('gD', Snacks.picker.lsp_symbols), 'Document Symbols')
          map('gD', Snacks.picker.lsp_symbols, 'Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>lS', deprecated('gW', Snacks.picker.lsp_workspace_symbols), 'Workspace Symbols')
          map('gW', Snacks.picker.lsp_workspace_symbols, 'Workspace Symbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>lr', deprecated('grn', require('renamer').rename), 'Rename LSP symbol', { 'n', 'x' })
          map('grn', require('renamer').rename, 'Rename LSP symbol', { 'n', 'x' })

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>la', deprecated('gra', vim.lsp.buf.code_action), 'Code Action', { 'n', 'x' })
          map('gra', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', Snacks.picker.lsp_declarations, 'Goto Declaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              ---@diagnostic disable-next-line: param-type-mismatch
              return client:supports_method(method, bufnr)
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                if vim.api.nvim_buf_is_valid(event2.buf) then
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          prefix = vim.g.virtual_symbol,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.

      -- Language servers can broadly be installed in the following ways:
      --  1) via the mason package manager; or
      --  2) via your system's package manager; or
      --  3) via a release binary from a language server's repo that's accessible somewhere on your system.

      -- The servers table comprises of the following sub-tables:
      -- 1. mason
      -- 2. others
      -- Both these tables have an identical structure of language server names as keys and
      -- a table of language server configuration as values.
      ---@class LspServersConfig
      ---@field mason table<string, vim.lsp.Config>
      ---@field others table<string, vim.lsp.Config>
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        -- rust_analyzer = {
        --   settings = {
        -- ['rust-analyzer'] = {
        --   check = {
        --     command = 'clippy',
        --   },
        --   imports = {
        --     granularity = {
        --       group = 'crate',
        --     },
        --   },
        --   procMacro = {
        --     enable = true,
        --   },
        -- },
        --   },
        -- },

        --  Feel free to add/remove any LSPs here that you want to install via Mason.
        --  They will automatically be installed and setup.
        mason = {
          lua_ls = {
            -- cmd = {...},
            -- filetypes = { ...},
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
          texlab = {
            settings = {
              texlab = {
                bibtexFormatter = 'latexindent',
                chktex = {
                  onEdit = false,
                  onOpenAndSave = true,
                },
              },
            },
          },
        },

        -- This table contains config for all language servers that are *not* installed via Mason.
        -- Structure is identical to the mason table from above.
        others = {
          -- dartls = {},
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers.mason or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
      -- to the default language server configs as provided by nvim-lspconfig or
      -- define a custom server config that's unavailable on nvim-lspconfig.
      for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
        if not vim.tbl_isempty(config) then
          vim.lsp.config(server, config)
        end
      end

      -- After configuring our language servers, we now enable them
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        automatic_enable = true,
      }

      -- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
      if not vim.tbl_isempty(servers.others) then
        vim.lsp.enable(vim.tbl_keys(servers.others))
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
