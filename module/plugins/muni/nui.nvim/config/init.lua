-- NUI.nvim configuration
local M = {}

function M.setup()
  -- Load all NUI component configs
  -- Note: config/ directory contents are flattened to plugins/MunifTanjim/nui-nvim/
  require("plugins.MunifTanjim.nui-nvim.border").setup()
  require("plugins.MunifTanjim.nui-nvim.input").setup()
  require("plugins.MunifTanjim.nui-nvim.menu").setup()
  require("plugins.MunifTanjim.nui-nvim.popup").setup()
end

return M
