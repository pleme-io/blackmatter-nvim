-- Completion group - orchestrates nvim-cmp and completion sources
-- Plugin configs now co-located with plugins
local M = {}

function M.setup()
  -- Setup nvim-cmp from its co-located config
  require("plugins.hrsh7th.nvim-cmp").setup()

  -- Load friendly-snippets into LuaSnip
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Snippet navigation keybindings
  local ls = require("luasnip")
  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.jumpable(1) then ls.jump(1) end
  end, { silent = true, desc = "Jump forward in snippet" })

  vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if ls.jumpable(-1) then ls.jump(-1) end
  end, { silent = true, desc = "Jump backward in snippet" })
end

return M
