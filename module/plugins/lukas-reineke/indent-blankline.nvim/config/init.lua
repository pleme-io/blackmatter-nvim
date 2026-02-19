-- plugins/lukas-reineke/indent-blankline.nvim/config/init.lua
local M = {}
function M.setup()
  require("groups.theming.indent-blankline").setup()
end
return M
