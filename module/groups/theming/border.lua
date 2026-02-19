local M = {}
function M.setup()
  vim.api.nvim_set_hl(0, "NuiBorder", { fg = "#4C566A", bg = "NONE" })
end
return M
