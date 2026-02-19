local M = {}
function M.setup()
  require("neotest").setup({
    adapters = {
      require("neotest-go"),
      require("neotest-jest")({
        jestCommand = "npx jest",
      }),
      require("neotest-python")({
        runner = "pytest",
      }),
      require("neotest-rust"),
      require("neotest-plenary"),
    },
    icons = {
      running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    },
    output_panel = {
      open = "botright split | resize 15",
    },
  })

  -- Failed test navigation
  vim.keymap.set("n", "]n", function()
    require("neotest").jump.next({ status = "failed" })
  end, { desc = "Next failed test" })

  vim.keymap.set("n", "[n", function()
    require("neotest").jump.prev({ status = "failed" })
  end, { desc = "Previous failed test" })
end
return M
