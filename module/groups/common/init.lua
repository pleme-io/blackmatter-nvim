local M = {}
function M.setup()
  require("groups.common.performance").setup()       -- disable built-ins, shellslash, etc.
  require("groups.common.settings").setup()          -- vim.opt & vim.g defaults
  require("groups.common.autocmds").setup()          -- yank highlight, restore cursor
  require("groups.common.undo").setup()              -- persistent undo dir
  require("groups.common.trim-whitespace").setup()   -- strip trailing spaces
  -- which-key.nvim self-configures via configDir (delegates to groups.common.which-key)
end
return M
