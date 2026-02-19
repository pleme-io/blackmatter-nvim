-- plugins/RRethy/vim-illuminate/config/init.lua
local M = {}
function M.setup()
  require("groups.lsp.illuminate").setup()
end
return M
