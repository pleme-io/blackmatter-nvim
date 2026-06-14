local M = {}
function M.setup()
  local base = require("groups.theming.colorscheme").base
  -- Vellum palette (gui hex, cterm twin). bufferline highlight specs accept
  -- ctermfg/ctermbg, so the bufferline stays colored without truecolor too.
  require("bufferline").setup({
    highlights = {
      fill                        = { bg = base, ctermbg = 233 },
      background                  = { bg = base, ctermbg = 233, fg = "#90897B", ctermfg = 245 },
      buffer_visible              = { bg = base, ctermbg = 233, fg = "#ADA593", ctermfg = 247 },
      buffer_selected             = { bg = base, ctermbg = 233, fg = "#EDE6D6", ctermfg = 254, bold = true },
      tab                         = { bg = base, ctermbg = 233, fg = "#90897B", ctermfg = 245 },
      tab_selected                = { bg = base, ctermbg = 233, fg = "#EDE6D6", ctermfg = 254, bold = true },
      tab_separator               = { bg = base, ctermbg = 233, fg = "#2B2820", ctermfg = 235 },
      tab_separator_selected      = { bg = base, ctermbg = 233, fg = "#2B2820", ctermfg = 235 },
      separator                   = { bg = base, ctermbg = 233, fg = "#2B2820", ctermfg = 235 },
      separator_visible           = { bg = base, ctermbg = 233, fg = "#2B2820", ctermfg = 235 },
      separator_selected          = { bg = base, ctermbg = 233, fg = "#2B2820", ctermfg = 235 },
      indicator_selected          = { fg = "#94BBB8", ctermfg = 109 },
      indicator_visible           = { fg = "#2B2820", ctermfg = 235 },
      modified                    = { fg = "#D7C489", ctermfg = 180 },
      modified_visible            = { fg = "#D7C489", ctermfg = 180 },
      modified_selected           = { fg = "#D7C489", ctermfg = 180 },
      close_button                = { bg = base, ctermbg = 233, fg = "#90897B", ctermfg = 245 },
      close_button_visible        = { bg = base, ctermbg = 233, fg = "#90897B", ctermfg = 245 },
      close_button_selected       = { bg = base, ctermbg = 233, fg = "#E2DBC8", ctermfg = 187 },
      duplicate                   = { fg = "#90897B", ctermfg = 245, italic = true },
      duplicate_visible           = { fg = "#90897B", ctermfg = 245, italic = true },
      duplicate_selected          = { fg = "#99AABE", ctermfg = 103, italic = true },
      error                       = { fg = "#C9837B", ctermfg = 174 },
      error_visible               = { fg = "#C9837B", ctermfg = 174 },
      error_selected              = { fg = "#C9837B", ctermfg = 174, bold = true },
      error_diagnostic            = { fg = "#C9837B", ctermfg = 174 },
      error_diagnostic_visible    = { fg = "#C9837B", ctermfg = 174 },
      error_diagnostic_selected   = { fg = "#C9837B", ctermfg = 174, bold = true },
      warning                     = { fg = "#D7C489", ctermfg = 180 },
      warning_visible             = { fg = "#D7C489", ctermfg = 180 },
      warning_selected            = { fg = "#D7C489", ctermfg = 180, bold = true },
      warning_diagnostic          = { fg = "#D7C489", ctermfg = 180 },
      warning_diagnostic_visible  = { fg = "#D7C489", ctermfg = 180 },
      warning_diagnostic_selected = { fg = "#D7C489", ctermfg = 180, bold = true },
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
