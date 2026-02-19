local M = {}
function M.setup()
  local Menu = require("nui.menu")
  vim.api.nvim_create_user_command("NuiMenu", function()
    local m = Menu({ border = { style = "single", text = { top = "Menu" } }, position = "50%", size = { width = 20, height = 5 } }, {
      lines = { Menu.item("Option 1"), Menu.item("Option 2") },
      max_width = 20,
      on_submit = function(item) print("Selected: " .. item.text); m:unmount() end,
      on_close  = function() m:unmount() end,
    })
    m:mount()
  end, { nargs = 0 })
end
return M
