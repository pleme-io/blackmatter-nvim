local M = {}
function M.setup()
  -- Cyan accent from the ACTIVE palette so the border follows the FLEET_THEME
  -- selector (Nord by default, Vellum when FLEET_THEME=vellum). cterm twin so
  -- the border stays colored without truecolor.
  local p = require("groups.theming.colorscheme").palette
  vim.api.nvim_set_hl(0, "NuiBorder", { fg = p.cyan.gui, ctermfg = p.cyan.cterm, bg = "NONE", ctermbg = "NONE" })
end
return M
