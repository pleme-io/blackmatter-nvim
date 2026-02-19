local M = {}
function M.setup()
  require("nvim-autopairs").setup()

  -- Integrate with nvim-cmp: auto-add ( after selecting a function
  local has_cmp, cmp = pcall(require, "cmp")
  if has_cmp then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end
return M
