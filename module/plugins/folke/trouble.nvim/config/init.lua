-- Trouble.nvim configuration - Beautiful diagnostics list
local M = {}

function M.setup()
  require("trouble").setup({
    auto_close = false,
    auto_open = false,
    auto_preview = true,
    auto_refresh = true,
    focus = false,
    modes = {
      -- Define custom modes for different use cases
      diagnostics = {
        mode = "diagnostics",
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
      },
    },
    icons = {
      indent = {
        middle = "├╴",
        last = "└╴",
        top = "│ ",
        ws = "  ",
      },
      folder_closed = " ",
      folder_open = " ",
      kinds = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        String = " ",
        Struct = "󰆼 ",
        TypeParameter = " ",
        Variable = "󰀫 ",
      },
    },
  })
end

return M
