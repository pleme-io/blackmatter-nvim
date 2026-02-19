local M = {}
function M.setup()
  require("oil").setup({
    default_file_explorer = true,
    columns = { "icon" },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-r>"] = "actions.refresh",
      ["q"] = "actions.close",
    },
  })
end
return M
