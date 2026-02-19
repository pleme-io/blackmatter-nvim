-- plugins/nvim-telescope/telescope.nvim/config/init.lua
local M = {}
function M.setup()
  require("groups.telescope.init").setup()
end
return M
