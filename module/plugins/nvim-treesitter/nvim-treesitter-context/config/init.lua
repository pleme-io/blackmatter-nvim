local M = {}
function M.setup()
  require("treesitter-context").setup({
    max_lines = 3,
    line_numbers = false,
    multiline_threshold = 1,
    trim_scope = "inner",
    separator = "─",
  })
end
return M
