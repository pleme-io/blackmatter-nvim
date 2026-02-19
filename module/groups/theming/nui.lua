local M = {}
function M.setup()
  require("groups.theming.border").setup()
  require("groups.theming.popup").setup()
  require("groups.theming.input").setup()
  require("groups.theming.menu").setup()
end
return M
