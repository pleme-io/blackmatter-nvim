-- plugins/lewis6991/gitsigns.nvim/config/init.lua
local M = {}
function M.setup()
  require("groups.theming.gitsigns").setup()
end
return M
