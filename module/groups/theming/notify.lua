local M = {}
function M.setup()
  local notify = require("notify")
  notify.setup({
    -- filter out LSP deprecation warnings
    filter = function(msg, level, opts)
      if type(msg) == "string"
         and msg:match("vim.lsp.util.parse_snippet")
         and msg:match("deprecated")
      then
        return false
      end
      return true
    end,
    -- animation and timing
    stages            = "fade_in_slide_out",
    render            = "minimal",
    timeout           = 3000,
    max_width         = 60,
    top_down          = true,
    background_colour = "#2E3440",
    fps               = 60,
  })

  -- override vim.notify to use nvim-notify
  vim.notify = notify

  -- command to view notification history
  vim.api.nvim_create_user_command("Notifications", function()
    notify.history()
  end, { nargs = 0 })
end
return M
