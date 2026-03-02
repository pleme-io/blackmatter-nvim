local M = {}

function M.setup()
  require("compass").setup({
    roots = { "~/code" },
    max_depth = 4,
    restore_last_file = true,
  })

  vim.keymap.set("n", "<leader>fp", "<cmd>Compass<CR>", { desc = "Find project" })
end

return M
