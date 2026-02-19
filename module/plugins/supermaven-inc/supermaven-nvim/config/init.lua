-- Supermaven AI completion configuration
-- Free AI completion with 1M token context window
local M = {}

function M.setup()
  require("supermaven-nvim").setup({
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    ignore_filetypes = { "help" },
    color = {
      suggestion_color = "#5E81AC", -- Nord blue for AI suggestions
      cterm = 244,
    },
    log_level = "off", -- Set to "info" for debugging
    disable_inline_completion = false, -- Show inline completions
    disable_keymaps = false,
  })

  -- Note: Supermaven provides both inline completions AND nvim-cmp source
  -- To use with nvim-cmp, add 'supermaven' to cmp sources in nvim-cmp config
end

return M
