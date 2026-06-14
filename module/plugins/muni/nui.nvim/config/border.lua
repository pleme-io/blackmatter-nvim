local M = {}
function M.setup()
  -- Vellum cyan accent; cterm twin so the border stays colored without truecolor.
  vim.api.nvim_set_hl(0, "NuiBorder", { fg = "#94BBB8", ctermfg = 109, bg = "NONE", ctermbg = "NONE" })
end
return M
