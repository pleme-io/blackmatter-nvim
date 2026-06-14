local M = {}

-- ── Vellum palette ───────────────────────────────────────────────────────
-- Warm aged-paper Nord-matte. Every value carries a gui hex AND the nearest
-- xterm-256 cterm index, so highlights stay colored even when termguicolors
-- is off (no truecolor terminal). cterm indices are approximate by design —
-- the goal is "never uncolored", not exact reproduction.
local p = {
  bg          = { gui = "#16140E", cterm = 233 },
  surface     = { gui = "#1F1C15", cterm = 234 },
  selection   = { gui = "#2B2820", cterm = 235 },
  comment     = { gui = "#90897B", cterm = 245 },
  dim         = { gui = "#ADA593", cterm = 247 },
  fg          = { gui = "#E2DBC8", cterm = 187 },
  fg_plus     = { gui = "#EDE6D6", cterm = 254 },
  fg_plus2    = { gui = "#F4EFE2", cterm = 230 },
  red         = { gui = "#C9837B", cterm = 174 },
  orange      = { gui = "#CB9070", cterm = 173 },
  yellow      = { gui = "#D7C489", cterm = 180 },
  green       = { gui = "#A9BB8C", cterm = 144 },
  cyan        = { gui = "#94BBB8", cterm = 109 },
  blue        = { gui = "#99AABE", cterm = 103 },
  purple      = { gui = "#B8A1B9", cterm = 139 },
  brown       = { gui = "#B3886C", cterm = 137 },
  cursor      = { gui = "#ADD7A3", cterm = 151 },
  border      = { gui = "#6E6857", cterm = 240 },
}

-- hl(group, spec) — spec keys fg/bg are Vellum palette entries (or the
-- literal "NONE"); every gui color gets its cterm twin written automatically,
-- so no override is ever gui-only. Style flags (bold/italic/...) pass through.
local function hl(group, spec)
  local out = {}
  for k, v in pairs(spec) do
    out[k] = v
  end
  if spec.fg ~= nil then
    if spec.fg == "NONE" then
      out.fg, out.ctermfg = "NONE", "NONE"
    else
      out.fg, out.ctermfg = spec.fg.gui, spec.fg.cterm
    end
  end
  if spec.bg ~= nil then
    if spec.bg == "NONE" then
      out.bg, out.ctermbg = "NONE", "NONE"
    else
      out.bg, out.ctermbg = spec.bg.gui, spec.bg.cterm
    end
  end
  if spec.sp ~= nil and spec.sp ~= "NONE" then
    out.sp = spec.sp.gui
  end
  vim.api.nvim_set_hl(0, group, out)
end

-- Expose the palette so this module's hl() and others can reuse it.
M.palette = p

function M.setup()
  -- Load the base colorscheme defensively. nord.nvim is the base the Vellum
  -- overrides sit on; if it ever fails to load (plugin missing, runtime error)
  -- we fall back to the built-in habamax so we are NEVER left on the bare
  -- terminal default. Either way the overrides below run.
  local ok = pcall(vim.cmd, "colorscheme nord")
  if not ok then
    pcall(vim.cmd, "colorscheme habamax")
    vim.schedule(function()
      vim.notify(
        "[theming] base colorscheme 'nord' failed to load — using 'habamax' fallback; Vellum overrides still applied",
        vim.log.levels.WARN
      )
    end)
  end

  -- expose your palette for others (legacy keys kept for bufferline etc.)
  M.base   = p.bg.gui
  M.popout = p.fg_plus.gui

  -- rounded borders on all floating windows (Neovim 0.11+)
  vim.o.winborder = "rounded"

  -- core editor surface
  hl("Normal",       { fg = p.fg, bg = p.bg })
  hl("Comment",      { fg = p.comment, italic = true })

  -- subtle float and cursor highlights
  hl("FloatBorder",  { fg = p.border, bg = "NONE" })
  hl("NormalFloat",  { bg = p.bg })
  hl("CursorLine",   { bg = p.surface })
  hl("CursorLineNr", { fg = p.cyan, bold = true })
  hl("Cursor",       { fg = p.bg, bg = p.cursor })

  -- search highlights — warm parchment accents
  hl("Search",    { fg = p.bg, bg = p.yellow })
  hl("IncSearch", { fg = p.bg, bg = p.orange })
  hl("CurSearch", { fg = p.bg, bg = p.green })

  -- visual selection
  hl("Visual",    { bg = p.selection })
  hl("VisualNOS", { bg = p.selection })

  -- treesitter-context — sticky scope header
  hl("TreesitterContext",          { bg = p.surface })
  hl("TreesitterContextSeparator", { fg = p.selection, bg = p.surface })

  -- line numbers — subdued, let code take focus
  hl("LineNr",     { fg = p.border })
  hl("SignColumn", { bg = "NONE" })
  hl("FoldColumn", { fg = p.border, bg = "NONE" })

  -- window separators — thin, barely there
  hl("WinSeparator", { fg = p.selection })

  -- completion menu — cohesive with floats
  hl("Pmenu",      { fg = p.fg, bg = p.surface })
  hl("PmenuSel",   { fg = p.fg_plus, bg = p.selection })
  hl("PmenuSbar",  { bg = p.selection })
  hl("PmenuThumb", { bg = p.border })

  -- diagnostics — Vellum mapping
  hl("DiagnosticError", { fg = p.red })
  hl("DiagnosticWarn",  { fg = p.yellow })
  hl("DiagnosticInfo",  { fg = p.cyan })
  hl("DiagnosticHint",  { fg = p.green })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = p.yellow })
  hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = p.cyan })
  hl("DiagnosticUnderlineHint",  { undercurl = true, sp = p.green })

  -- matching brackets — accent, not neon
  hl("MatchParen", { fg = p.cyan, bg = p.selection, bold = true })

  -- word highlighting (vim-illuminate) — subtle same-word emphasis
  hl("IlluminatedWordText",  { bg = p.surface })
  hl("IlluminatedWordRead",  { bg = p.surface })
  hl("IlluminatedWordWrite", { bg = p.surface, underline = true })

  -- folds — muted, out of the way
  hl("Folded", { fg = p.comment, bg = p.surface })

  -- invisible characters — nearly invisible
  hl("NonText",    { fg = p.selection })
  hl("Whitespace", { fg = p.selection })

  -- telescope — recessed borders, warm accents on titles
  hl("TelescopeBorder",        { fg = p.selection })
  hl("TelescopePromptBorder",  { fg = p.border })
  hl("TelescopeResultsBorder", { fg = p.selection })
  hl("TelescopePreviewBorder", { fg = p.selection })
  hl("TelescopePromptTitle",   { fg = p.cyan, bold = true })
  hl("TelescopeResultsTitle",  { fg = p.green })
  hl("TelescopePreviewTitle",  { fg = p.blue })
  hl("TelescopeSelection",     { bg = p.surface })
  hl("TelescopePromptPrefix",  { fg = p.cyan })

  -- git blame — italic, recedes into background
  hl("GitSignsCurrentLineBlame", { fg = p.border, italic = true })

  -- floating window titles — consistent accent
  hl("FloatTitle", { fg = p.cyan, bold = true })

  -- completion match highlighting — accent on matched characters
  hl("CmpItemAbbrMatch",      { fg = p.cyan, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.cyan })
  hl("CmpItemAbbrDeprecated", { fg = p.border, strikethrough = true })
  hl("CmpItemKindFunction",   { fg = p.cyan })
  hl("CmpItemKindMethod",     { fg = p.cyan })
  hl("CmpItemKindVariable",   { fg = p.blue })
  hl("CmpItemKindField",      { fg = p.blue })
  hl("CmpItemKindProperty",   { fg = p.blue })
  hl("CmpItemKindClass",      { fg = p.yellow })
  hl("CmpItemKindStruct",     { fg = p.yellow })
  hl("CmpItemKindInterface",  { fg = p.yellow })
  hl("CmpItemKindModule",     { fg = p.green })
  hl("CmpItemKindKeyword",    { fg = p.purple })
  hl("CmpItemKindSnippet",    { fg = p.orange })
  hl("CmpItemKindText",       { fg = p.fg })
  hl("CmpItemKindFile",       { fg = p.fg })
  hl("CmpItemKindFolder",     { fg = p.fg })

  -- notifications — severity-colored borders and icons
  hl("NotifyERRORBorder", { fg = p.red })
  hl("NotifyWARNBorder",  { fg = p.yellow })
  hl("NotifyINFOBorder",  { fg = p.cyan })
  hl("NotifyDEBUGBorder", { fg = p.border })
  hl("NotifyTRACEBorder", { fg = p.purple })
  hl("NotifyERRORIcon",   { fg = p.red })
  hl("NotifyWARNIcon",    { fg = p.yellow })
  hl("NotifyINFOIcon",    { fg = p.cyan })
  hl("NotifyDEBUGIcon",   { fg = p.border })
  hl("NotifyTRACEIcon",   { fg = p.purple })
  hl("NotifyERRORTitle",  { fg = p.red })
  hl("NotifyWARNTitle",   { fg = p.yellow })
  hl("NotifyINFOTitle",   { fg = p.cyan })
  hl("NotifyDEBUGTitle",  { fg = p.border })
  hl("NotifyTRACETitle",  { fg = p.purple })

  -- trouble — custom window styling
  hl("TroubleNormal",   { bg = p.bg })
  hl("TroubleNormalNC", { bg = p.bg })
  hl("TroubleCount",    { fg = p.cyan, bold = true })
  hl("TroubleIndent",   { fg = p.selection })

  -- lsp signature active parameter — stand out in param list
  hl("LspSignatureActiveParameter", { fg = p.yellow, bold = true, underline = true })

  -- inline color previews for CSS/HTML/etc.
  local has_colorizer, colorizer = pcall(require, "colorizer")
  if has_colorizer then
    colorizer.setup({
      filetypes = {
        "css", "scss", "html", "lua", "conf", "yaml", "toml",
        css = { css = true, css_fn = true, mode = "background" },
        scss = { css = true, css_fn = true, mode = "background" },
        html = { css = true, css_fn = true, mode = "background" },
        lua = { mode = "virtualtext" },
        conf = { mode = "virtualtext" },
        yaml = { mode = "virtualtext" },
        toml = { mode = "virtualtext" },
      },
      user_default_options = {
        names = false,
        mode = "virtualtext",
        virtualtext = "■",
      },
    })
  end
end

return M
