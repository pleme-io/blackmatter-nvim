local M = {}
function M.setup()
  require("treesitter-context").setup({
    max_lines = 3,
  })
end
return M
