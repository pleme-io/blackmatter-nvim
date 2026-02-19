-- Installed so other plugins (snacks.nvim) can detect it,
-- but popup is disabled — user prefers memorizing keybindings.
local M = {}
function M.setup()
  local has_wk, wk = pcall(require, "which-key")
  if not has_wk then return end

  wk.setup({
    -- Disable the popup entirely
    triggers = {},
  })

  -- Register leader group prefixes for discoverability
  wk.add({
    { "<leader>f", group = "find" },
    { "<leader>h", group = "git hunks" },
    { "<leader>d", group = "diagnostics" },
    { "<leader>r", group = "rename" },
    { "<leader>c", group = "code" },
    { "<leader>x", group = "trouble" },
    { "<leader>s", group = "split" },
    { "<leader>b", group = "buffer" },
    { "<leader>g", group = "git" },
    { "<leader>t", group = "terminal" },
    { "<leader>n", group = "neotest" },
    { "<leader>a", desc = "swap next parameter" },
    { "<leader>A", desc = "swap previous parameter" },
  })
end
return M
