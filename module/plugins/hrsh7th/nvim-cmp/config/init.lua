-- nvim-cmp plugin configuration
-- Co-located with plugin declaration for single responsibility

local M = {}

function M.setup(opts)
  opts = opts or {}

  local cmp = require("cmp")
  local mappings = require("plugins.hrsh7th.nvim-cmp.mappings")
  local sources = require("plugins.hrsh7th.nvim-cmp.sources")

  -- Set completeopt for better completion experience
  vim.cmd([[ set completeopt=menu,menuone,noselect ]])

  -- lspkind formatting for VSCode-like icons in completion menu
  local has_lspkind, lspkind = pcall(require, "lspkind")
  local formatting = {}
  if has_lspkind then
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
        menu = {
          nvim_lsp = "[LSP]",
          buffer = "[Buf]",
          path = "[Path]",
          treesitter = "[TS]",
          codeium = "[AI]",
          luasnip = "[Snip]",
          cmdline = "[Cmd]",
        },
      }),
    }
  end

  -- Setup nvim-cmp
  cmp.setup({
    mapping = mappings.get(),
    sources = cmp.config.sources(sources.get()),
    formatting = formatting,
    -- Allow opts to override defaults
    snippet = opts.snippet or {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
end

return M
