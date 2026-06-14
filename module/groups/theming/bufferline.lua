local M = {}
function M.setup()
  -- Read the ACTIVE palette so the bufferline follows the FLEET_THEME selector
  -- (classic Nord by default, warm Vellum when FLEET_THEME=vellum). bufferline
  -- highlight specs accept ctermfg/ctermbg, so it stays colored without
  -- truecolor too — every gui hex below carries its cterm twin from the palette.
  local p    = require("groups.theming.colorscheme").palette
  local base = p.bg.gui
  local cbg  = p.bg.cterm
  require("bufferline").setup({
    highlights = {
      fill                        = { bg = base, ctermbg = cbg },
      background                  = { bg = base, ctermbg = cbg, fg = p.comment.gui, ctermfg = p.comment.cterm },
      buffer_visible              = { bg = base, ctermbg = cbg, fg = p.dim.gui, ctermfg = p.dim.cterm },
      buffer_selected             = { bg = base, ctermbg = cbg, fg = p.fg_plus.gui, ctermfg = p.fg_plus.cterm, bold = true },
      tab                         = { bg = base, ctermbg = cbg, fg = p.comment.gui, ctermfg = p.comment.cterm },
      tab_selected                = { bg = base, ctermbg = cbg, fg = p.fg_plus.gui, ctermfg = p.fg_plus.cterm, bold = true },
      tab_separator               = { bg = base, ctermbg = cbg, fg = p.selection.gui, ctermfg = p.selection.cterm },
      tab_separator_selected      = { bg = base, ctermbg = cbg, fg = p.selection.gui, ctermfg = p.selection.cterm },
      separator                   = { bg = base, ctermbg = cbg, fg = p.selection.gui, ctermfg = p.selection.cterm },
      separator_visible           = { bg = base, ctermbg = cbg, fg = p.selection.gui, ctermfg = p.selection.cterm },
      separator_selected          = { bg = base, ctermbg = cbg, fg = p.selection.gui, ctermfg = p.selection.cterm },
      indicator_selected          = { fg = p.cyan.gui, ctermfg = p.cyan.cterm },
      indicator_visible           = { fg = p.selection.gui, ctermfg = p.selection.cterm },
      modified                    = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      modified_visible            = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      modified_selected           = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      close_button                = { bg = base, ctermbg = cbg, fg = p.comment.gui, ctermfg = p.comment.cterm },
      close_button_visible        = { bg = base, ctermbg = cbg, fg = p.comment.gui, ctermfg = p.comment.cterm },
      close_button_selected       = { bg = base, ctermbg = cbg, fg = p.fg.gui, ctermfg = p.fg.cterm },
      duplicate                   = { fg = p.comment.gui, ctermfg = p.comment.cterm, italic = true },
      duplicate_visible           = { fg = p.comment.gui, ctermfg = p.comment.cterm, italic = true },
      duplicate_selected          = { fg = p.blue.gui, ctermfg = p.blue.cterm, italic = true },
      error                       = { fg = p.red.gui, ctermfg = p.red.cterm },
      error_visible               = { fg = p.red.gui, ctermfg = p.red.cterm },
      error_selected              = { fg = p.red.gui, ctermfg = p.red.cterm, bold = true },
      error_diagnostic            = { fg = p.red.gui, ctermfg = p.red.cterm },
      error_diagnostic_visible    = { fg = p.red.gui, ctermfg = p.red.cterm },
      error_diagnostic_selected   = { fg = p.red.gui, ctermfg = p.red.cterm, bold = true },
      warning                     = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      warning_visible             = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      warning_selected            = { fg = p.yellow.gui, ctermfg = p.yellow.cterm, bold = true },
      warning_diagnostic          = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      warning_diagnostic_visible  = { fg = p.yellow.gui, ctermfg = p.yellow.cterm },
      warning_diagnostic_selected = { fg = p.yellow.gui, ctermfg = p.yellow.cterm, bold = true },
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
