local M = {}
function M.setup()
  local has_ibl, ibl = pcall(require, "ibl")
  if not has_ibl then return end

  -- Define subtle highlight groups for indent guides (Vellum + cterm twins)
  vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2B2820", ctermfg = 235 })
  vim.api.nvim_set_hl(0, "IblScope", { fg = "#6E6857", ctermfg = 240 })

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
