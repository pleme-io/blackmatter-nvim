local M = {}
function M.setup()
  local Input = require("nui.input")
  vim.api.nvim_create_user_command("NuiInput", function()
    local i = Input({ border = { style = "rounded", text = { top = "Input?" } }, position = "50%", size = { width = 30 } }, {
      prompt = "> ", default_value = "",
      on_submit = function(val) print("You entered: " .. val); i:unmount() end,
      on_close  = function() i:unmount() end,
    })
    i:mount()
  end, { nargs = 0 })
end
return M
