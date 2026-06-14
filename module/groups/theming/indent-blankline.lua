local M = {}
function M.setup()
  local has_ibl, ibl = pcall(require, "ibl")
  if not has_ibl then return end

  -- Subtle indent-guide highlights from the ACTIVE palette so they follow the
  -- FLEET_THEME selector (Nord by default, Vellum when FLEET_THEME=vellum).
  -- cterm twins keep guides visible without truecolor.
  local p = require("groups.theming.colorscheme").palette
  vim.api.nvim_set_hl(0, "IblIndent", { fg = p.selection.gui, ctermfg = p.selection.cterm })
  vim.api.nvim_set_hl(0, "IblScope",  { fg = p.border.gui,    ctermfg = p.border.cterm })

  ibl.setup({
    indent = {
      char = "▏",
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      highlight = "IblScope",
    },
    exclude = {
      filetypes = { "help", "dashboard", "lazy", "mason", "notify", "trouble", "oil", "sagaoutline" },
    },
  })
end
return M
