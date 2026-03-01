-- Tiny inline diagnostic - Beautiful inline error display
local M = {}

function M.setup()
  require("tiny-inline-diagnostic").setup({
    preset = "modern", -- Can be: "modern", "classic", "minimal", "ghost", "simple", "nonerdfont", "amongus"
    options = {
      show_source = true,
      throttle = 20,
      multilines = {
        enabled = true,
      },
      overflow = {
        mode = "wrap",
      },
    },
  })

  -- Disable default virtual text since tiny-inline-diagnostic replaces it
  vim.diagnostic.config({
    virtual_text = false,
  })
end

return M
