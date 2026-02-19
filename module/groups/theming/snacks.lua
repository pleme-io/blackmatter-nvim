local M = {}
function M.setup()
  require("snacks").setup({
    notifications = { enabled = true, timeout = 3000 },
    input = { enabled = true },
    select = { enabled = true },
    quickfix = { enabled = true },
    commandline = { enabled = true },
  })
end
return M
