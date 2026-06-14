local M = {}

-- ── Fleet-themed lualine theme ───────────────────────────────────────────
-- Inline theme so the statusline shows colored pills (fixes the "all-white
-- lualine" the operator saw when `theme = "nord"` collapsed). Mode colors use
-- DARK ink on bright accents; sections b/c sit on the surface tone. The whole
-- theme is derived from the ACTIVE palette in groups.theming.colorscheme, so
-- it follows the FLEET_THEME selector (classic Nord by default, warm Vellum
-- when FLEET_THEME=vellum). cterm twins included so it stays colored without
-- truecolor.
local cs = require("groups.theming.colorscheme")
local p  = cs.palette

-- pill(accent) → a {a,b,c} section spec for one mode, dark ink on the accent.
local function pill(accent)
  return {
    a = { fg = p.bg.gui, bg = accent.gui,
          ctermfg = p.bg.cterm, ctermbg = accent.cterm, gui = "bold" },
    b = { fg = p.fg.gui, bg = p.surface.gui,
          ctermfg = p.fg.cterm, ctermbg = p.surface.cterm },
    c = { fg = p.fg.gui, bg = p.surface.gui,
          ctermfg = p.fg.cterm, ctermbg = p.surface.cterm },
  }
end

local fleet_theme = {
  normal   = pill(p.cyan),
  insert   = pill(p.green),
  visual   = pill(p.purple),
  replace  = pill(p.red),
  command  = pill(p.yellow),
  inactive = {
    a = { fg = p.fg.gui, bg = p.selection.gui,
          ctermfg = p.fg.cterm, ctermbg = p.selection.cterm },
    b = { fg = p.fg.gui, bg = p.selection.gui,
          ctermfg = p.fg.cterm, ctermbg = p.selection.cterm },
    c = { fg = p.fg.gui, bg = p.selection.gui,
          ctermfg = p.fg.cterm, ctermbg = p.selection.cterm },
  },
}

function M.setup()
  require("lualine").setup({
    options = {
      theme              = fleet_theme,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      icons_enabled      = true,
      globalstatus       = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          diff_color = {
            added    = { fg = p.green.gui },
            modified = { fg = p.yellow.gui },
            removed  = { fg = p.red.gui },
          },
        },
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          diagnostics_color = {
            error = { fg = p.red.gui },
            warn  = { fg = p.yellow.gui },
            info  = { fg = p.cyan.gui },
            hint  = { fg = p.green.gui },
          },
        },
      },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
      },
      lualine_x = {
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        },
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return " " .. table.concat(names, ", ")
          end,
        },
        { "filetype", icon_only = false },
      },
      lualine_y = { "searchcount", "selectioncount", "progress" },
      lualine_z = { "location" },
    },
  })
end
return M
