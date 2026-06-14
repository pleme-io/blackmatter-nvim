local M = {}

-- ── Vellum lualine theme ─────────────────────────────────────────────────
-- Inline theme so the statusline shows warm colored pills (fixes the
-- "all-white lualine" the operator saw when `theme = "nord"` collapsed).
-- Mode colors use DARK text (#16140E) on bright Vellum accents; sections b/c
-- sit on the surface tone. cterm twins included so it stays colored without
-- truecolor.
local vellum = {
  bg_dark   = { gui = "#16140E", cterm = 233 }, -- ink (dark text on pills)
  surface   = { gui = "#1F1C15", cterm = 234 }, -- section b/c bg
  selection = { gui = "#2B2820", cterm = 235 },
  fg        = { gui = "#CDC7B6", cterm = 187 }, -- section b/c fg
  cyan      = { gui = "#94BBB8", cterm = 109 }, -- normal
  green     = { gui = "#A9BB8C", cterm = 144 }, -- insert
  purple    = { gui = "#B8A1B9", cterm = 139 }, -- visual
  red       = { gui = "#C9837B", cterm = 174 }, -- replace
  yellow    = { gui = "#D7C489", cterm = 180 }, -- command
}

-- pill(accent) → a {a,b,c} section spec for one mode, dark ink on the accent.
local function pill(accent)
  return {
    a = { fg = vellum.bg_dark.gui, bg = accent.gui,
          ctermfg = vellum.bg_dark.cterm, ctermbg = accent.cterm, gui = "bold" },
    b = { fg = vellum.fg.gui, bg = vellum.surface.gui,
          ctermfg = vellum.fg.cterm, ctermbg = vellum.surface.cterm },
    c = { fg = vellum.fg.gui, bg = vellum.surface.gui,
          ctermfg = vellum.fg.cterm, ctermbg = vellum.surface.cterm },
  }
end

local vellum_theme = {
  normal   = pill(vellum.cyan),
  insert   = pill(vellum.green),
  visual   = pill(vellum.purple),
  replace  = pill(vellum.red),
  command  = pill(vellum.yellow),
  inactive = {
    a = { fg = vellum.fg.gui, bg = vellum.selection.gui,
          ctermfg = vellum.fg.cterm, ctermbg = vellum.selection.cterm },
    b = { fg = vellum.fg.gui, bg = vellum.selection.gui,
          ctermfg = vellum.fg.cterm, ctermbg = vellum.selection.cterm },
    c = { fg = vellum.fg.gui, bg = vellum.selection.gui,
          ctermfg = vellum.fg.cterm, ctermbg = vellum.selection.cterm },
  },
}

function M.setup()
  require("lualine").setup({
    options = {
      theme              = vellum_theme,
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
            added    = { fg = "#A9BB8C" },
            modified = { fg = "#D7C489" },
            removed  = { fg = "#C9837B" },
          },
        },
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          diagnostics_color = {
            error = { fg = "#C9837B" },
            warn  = { fg = "#D7C489" },
            info  = { fg = "#94BBB8" },
            hint  = { fg = "#A9BB8C" },
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
