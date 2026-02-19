-- modules/.../groups/ui/noice.lua
local M = {}
function M.setup()
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.schedule(function()
        require("noice").setup({
          messages = { enabled = false },

          routes = {
            {
              filter = { event = "msg_show" },
              opts   = { skip = true },
            },
          },

          cmdline   = { enabled = false },
          popupmenu = { enabled = false, backend = "nui" },
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"]              = true,
              ["cmp.entry.get_documentation"]                = true,
            },
          },
          presets = {
            bottom_search         = true,
            command_palette       = true,
            long_message_to_split = true,
            inc_rename            = true,
            lsp_doc_border        = true,
          },
        })
      end)
    end,
  })
end
return M
