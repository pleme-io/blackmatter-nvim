local M = {}
function M.setup()
  local base = require("groups.theming.colorscheme").base
  require("bufferline").setup({
    highlights = {
      fill                        = { bg = base },
      background                  = { bg = base, fg = "#4C566A" },
      buffer_visible              = { bg = base, fg = "#616E88" },
      buffer_selected             = { bg = base, fg = "#ECEFF4", bold = true },
      tab                         = { bg = base, fg = "#4C566A" },
      tab_selected                = { bg = base, fg = "#ECEFF4", bold = true },
      tab_separator               = { bg = base, fg = "#3B4252" },
      tab_separator_selected      = { bg = base, fg = "#3B4252" },
      separator                   = { bg = base, fg = "#3B4252" },
      separator_visible           = { bg = base, fg = "#3B4252" },
      separator_selected          = { bg = base, fg = "#3B4252" },
      indicator_selected          = { fg = "#88C0D0" },
      indicator_visible           = { fg = "#3B4252" },
      modified                    = { fg = "#EBCB8B" },
      modified_visible            = { fg = "#EBCB8B" },
      modified_selected           = { fg = "#EBCB8B" },
      close_button                = { bg = base, fg = "#4C566A" },
      close_button_visible        = { bg = base, fg = "#4C566A" },
      close_button_selected       = { bg = base, fg = "#D8DEE9" },
      duplicate                   = { fg = "#4C566A", italic = true },
      duplicate_visible           = { fg = "#4C566A", italic = true },
      duplicate_selected          = { fg = "#81A1C1", italic = true },
      error                       = { fg = "#BF616A" },
      error_visible               = { fg = "#BF616A" },
      error_selected              = { fg = "#BF616A", bold = true },
      error_diagnostic            = { fg = "#BF616A" },
      error_diagnostic_visible    = { fg = "#BF616A" },
      error_diagnostic_selected   = { fg = "#BF616A", bold = true },
      warning                     = { fg = "#EBCB8B" },
      warning_visible             = { fg = "#EBCB8B" },
      warning_selected            = { fg = "#EBCB8B", bold = true },
      warning_diagnostic          = { fg = "#EBCB8B" },
      warning_diagnostic_visible  = { fg = "#EBCB8B" },
      warning_diagnostic_selected = { fg = "#EBCB8B", bold = true },
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
