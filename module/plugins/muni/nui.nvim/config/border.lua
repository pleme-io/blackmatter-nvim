local M = {}
function M.setup()
  vim.api.nvim_set_hl(0, "NuiBorder", { fg = "#88C0D0", bg = "NONE" })
end
return M
