-- Tiny inline diagnostic - Beautiful inline error display
local M = {}

function M.setup()
  require("tiny-inline-diagnostic").setup({
    preset = "modern", -- Can be: "modern", "classic", "minimal", "ghost", "simple", "nonerdfont", "amongus"
    options = {
      -- Show diagnostic messages inline where cursor is
      show_source = true,
      throttle = 20,
      -- Nord-themed colors
      multilines = {
        enabled = true,
      },
      overflow = {
        mode = "none", -- "none" truncates to the right of code; "wrap" stacks above
      },
    },
  })

  -- Disable default virtual text since tiny-inline-diagnostic replaces it
  vim.diagnostic.config({
    virtual_text = false,
  })
end

return M
