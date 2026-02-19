-- plugins/folke/which-key.nvim/config/init.lua
local M = {}
function M.setup()
  require("groups.common.which-key").setup()
end
return M
