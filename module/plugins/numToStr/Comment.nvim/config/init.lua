local M = {}
function M.setup()
  require("Comment").setup({
    -- Use ts-context-commentstring for context-aware commenting (JSX, HTML, etc.)
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  })
end
return M
