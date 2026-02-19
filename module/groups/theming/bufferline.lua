local M = {}
function M.setup()
  local base, popout = unpack({require("groups.theming.colorscheme").base,
                               require("groups.theming.colorscheme").popout})
  require("bufferline").setup({
    highlights = {
      separator         = { bg = base, fg = popout },
      fill              = { bg = base },
      background        = { bg = base },
      tab               = { bg = base },
      tab_selected      = { bg = base, fg = popout },
      buffer_visible    = { bg = base },
      buffer_selected   = { bg = base, fg = popout, bold = true },
      close_button      = { bg = base },
      close_button_selected = { bg = base },
    },
    options = {
      numbers               = "buffer_id",
      mode                  = "buffers",
      diagnostics           = "nvim_lsp",
      diagnostics_indicator  = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      separator_style       = "thin",
      show_buffer_close_icons = false,
      show_close_icon       = false,
      enforce_regular_tabs  = false,
      always_show_bufferline= true,
      modified_icon         = "● ",
      indicator             = { style = "icon", icon = "▎" },
      offsets = {{
        filetype   = "NvimTree",
        text       = "File Explorer",
        text_align = "left",
      }},
    },
  })
end
return M
