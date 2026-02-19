local M = {}
function M.setup()
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event
  -- vim.api.nvim_create_autocmd(event.VimEnter, {
  --   once = true,
  --   callback = function()
  --     local p = Popup({ border = { style = "rounded" }, position = "50%", size = { width = 50, height = 5 } })
  --     p:mount()
  --     -- vim.api.nvim_buf_set_lines(p.bufnr, 0, -1, false, { "✨ Welcome to Neovim with NUI!" })
  --     p:on(event.BufLeave, function() p:unmount() end)
  --   end
  -- })
end
return M
