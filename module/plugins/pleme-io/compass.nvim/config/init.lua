local M = {}

function M.setup()
  require("compass").setup({
    roots = { "~/code" },
    max_depth = 4,
    restore_last_file = true,
  })
end

return M
