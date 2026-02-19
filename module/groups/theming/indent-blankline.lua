local M = {}
function M.setup()
  local has_ibl, ibl = pcall(require, "ibl")
  if not has_ibl then return end

  -- Define subtle highlight groups for indent guides
  vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B4252" })
  vim.api.nvim_set_hl(0, "IblScope", { fg = "#5E81AC" })

  ibl.setup({
    indent = {
      char = "│",
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      highlight = "IblScope",
    },
    exclude = {
      filetypes = { "help", "dashboard", "lazy", "mason", "notify", "trouble" },
    },
  })
end
return M
