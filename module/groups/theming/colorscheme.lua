local M = {}

-- ── Fleet theme selector ─────────────────────────────────────────────────
-- "nord"   (default) — classic Nord, renders IDENTICALLY to ghostty's Nord
--                      (bg #2E3440, fg #ECEFF4, Nord aurora/frost syntax).
-- "vellum"          — warm aged-paper Nord-matte (the saved alternate ground).
-- Select at launch with the FLEET_THEME env var, e.g. `FLEET_THEME=vellum nvim`.
-- This single flag is the source of truth — every theme-coupled satellite
-- module (lualine / bufferline / gitsigns / indent-blankline / border /
-- notify / the snacks dashboard logo) reads the resolved palette below,
-- so flipping FLEET_THEME repaints the whole UI in one place.
local FLEET_THEME = (vim.env.FLEET_THEME ~= nil and vim.env.FLEET_THEME ~= "" and vim.env.FLEET_THEME) or "nord"
M.theme = FLEET_THEME

-- ── Vellum palette (warm aged-paper, saved) ──────────────────────────────
-- Every value carries a gui hex AND the nearest xterm-256 cterm index, so
-- highlights stay colored even when termguicolors is off (no truecolor
-- terminal). cterm indices are approximate by design — the goal is "never
-- uncolored", not exact reproduction.
local vellum = {
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

-- ── Nord palette (classic, matches ghostty exactly) ──────────────────────
-- Ground = Nord polar-night / snow-storm; chrome accents = Nord frost/aurora.
-- These hexes are byte-identical to ghostty's deployed Nord palette so nvim's
-- own background (#2E3440), fg (#ECEFF4), cursor (#88C0D0) and selection
-- (#4C566A) match the surrounding terminal pixel-for-pixel. cterm twins pin
-- the nearest xterm-256 index so a non-truecolor session still shows Nord.
local nord = {
  bg          = { gui = "#2E3440", cterm = 236 }, -- polar night nord0
  surface     = { gui = "#3B4252", cterm = 237 }, -- polar night nord1 (cursorline/float)
  selection   = { gui = "#434C5E", cterm = 238 }, -- polar night nord2 (visual)
  comment     = { gui = "#616E88", cterm = 60  }, -- Nord muted comment blue-grey
  dim         = { gui = "#D8DEE9", cterm = 188 }, -- snow storm nord4
  fg          = { gui = "#ECEFF4", cterm = 255 }, -- snow storm nord6
  fg_plus     = { gui = "#ECEFF4", cterm = 255 },
  fg_plus2    = { gui = "#ECEFF4", cterm = 231 },
  red         = { gui = "#BF616A", cterm = 167 }, -- aurora red
  orange      = { gui = "#D08770", cterm = 173 }, -- aurora orange
  yellow      = { gui = "#EBCB8B", cterm = 222 }, -- aurora yellow
  green       = { gui = "#A3BE8C", cterm = 108 }, -- aurora green
  cyan        = { gui = "#88C0D0", cterm = 116 }, -- frost nord8
  blue        = { gui = "#81A1C1", cterm = 110 }, -- frost nord9
  purple      = { gui = "#B48EAD", cterm = 139 }, -- aurora purple
  brown       = { gui = "#D08770", cterm = 173 }, -- (no Nord brown — reuse orange)
  cursor      = { gui = "#88C0D0", cterm = 116 }, -- ghostty cursor = nord8
  border      = { gui = "#4C566A", cterm = 240 }, -- polar night nord3 (selection-bg)
}

-- The active CHROME/GROUND palette. nord by default, vellum when selected.
local p = (FLEET_THEME == "vellum") and vellum or nord

-- ── Content accents (vivid Nord) ─────────────────────────────────────────
-- The chrome palette `p` is intentionally low-contrast for borders, pills,
-- gutter signs. Those muted tones are WRONG for code: a keyword, a string,
-- a type and a function name would collapse into one dim wash.
--
-- `c` is the separate CODE palette: the vivid Nord "content" 16 (the fleet
-- keystone `ishou_tokens::Palette::content_ansi_16()`). These paint SYNTAX
-- and TREESITTER groups only — chrome keeps using `p`. The content accents
-- are the SAME under both grounds (they are already classic Nord), so syntax
-- stays vivid Nord whether the ground is parchment or polar-night. cterm
-- twins are tuned to bright 256-color approximations so a non-truecolor
-- session still differentiates keyword vs string vs function vs type.
local c = {
  red     = { gui = "#BF616A", cterm = 167 }, -- error / removed
  green   = { gui = "#A3BE8C", cterm = 108 }, -- string / added
  yellow  = { gui = "#EBCB8B", cterm = 222 }, -- class / search
  blue    = { gui = "#81A1C1", cterm = 110 }, -- function name (bright frost-3)
  blue_dk = { gui = "#5E81AC", cterm = 67 },  -- deeper blue (namespace/builtin fn)
  magenta = { gui = "#B48EAD", cterm = 139 }, -- keyword / statement
  cyan    = { gui = "#88C0D0", cterm = 116 }, -- type / special
  orange  = { gui = "#D08770", cterm = 173 }, -- number / constant / parameter
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

-- Expose the palettes so this module's hl() and the theme-coupled satellite
-- modules (lualine / bufferline / gitsigns / indent-blankline / border /
-- notify / snacks dashboard) can reuse the ACTIVE palette.
--   M.palette  — resolved CHROME/GROUND palette (nord by default, vellum when
--                FLEET_THEME=vellum); each entry is { gui = "#…", cterm = N }.
--   M.content  — vivid Nord CODE accents (same under both grounds).
--   M.theme    — the active selector ("nord" | "vellum").
-- Both raw palettes stay exported so a satellite can pin a specific ground or
-- so the Vellum theme is never lost — it is restorable via FLEET_THEME=vellum.
M.palette       = p
M.content       = c
M.palette_nord  = nord
M.palette_vellum = vellum

function M.setup()
  -- Load the base colorscheme defensively. nord.nvim is the base our overrides
  -- sit on; if it ever fails to load (plugin missing, runtime error) we fall
  -- back to the built-in habamax so we are NEVER left on the bare terminal
  -- default. Either way the overrides below run.
  --
  -- Under FLEET_THEME=nord (default) the base nord.nvim already provides the
  -- classic Nord ground that matches ghostty; our `p` override re-pins that
  -- exact ground (bg #2E3440 / fg #ECEFF4 / etc.) so every chrome group is
  -- guaranteed Nord even if the plugin's defaults drift, and the satellite
  -- modules read the same resolved palette. Under FLEET_THEME=vellum the same
  -- override block instead paints the warm parchment ground.
  local ok = pcall(vim.cmd, "colorscheme nord")
  if not ok then
    pcall(vim.cmd, "colorscheme habamax")
    vim.schedule(function()
      vim.notify(
        "[theming] base colorscheme 'nord' failed to load — using 'habamax' fallback; "
          .. M.theme .. " overrides still applied",
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

  -- ── Vivid content syntax (legacy regex groups) ────────────────────────
  -- Repaint the legacy syntax groups (used by vim regex syntax, e.g. the
  -- nix.vim highlighter — treesitter is disabled for nix) with the vivid
  -- Nord CONTENT palette `c`. These accents are identical under both grounds,
  -- so syntax stays vivid classic Nord whether the ground is nord polar-night
  -- (default) or warm parchment (FLEET_THEME=vellum). Comments use the active
  -- ground's muted comment tone (p.comment); Normal fg/bg untouched above.
  hl("Comment",        { fg = p.comment, italic = true })

  hl("Constant",       { fg = c.orange })
  hl("String",         { fg = c.green })
  hl("Character",      { fg = c.green })
  hl("Number",         { fg = c.orange })
  hl("Boolean",        { fg = c.orange })
  hl("Float",          { fg = c.orange })

  hl("Identifier",     { fg = p.fg })
  hl("Function",       { fg = c.blue })

  hl("Statement",      { fg = c.magenta })
  hl("Conditional",    { fg = c.magenta })
  hl("Repeat",         { fg = c.magenta })
  hl("Label",          { fg = c.magenta })
  hl("Operator",       { fg = c.cyan })
  hl("Keyword",        { fg = c.magenta })
  hl("Exception",      { fg = c.magenta })

  hl("PreProc",        { fg = c.cyan })
  hl("Include",        { fg = c.magenta })
  hl("Define",         { fg = c.magenta })
  hl("Macro",          { fg = c.cyan })
  hl("PreCondit",      { fg = c.cyan })

  hl("Type",           { fg = c.cyan })
  hl("StorageClass",   { fg = c.cyan })
  hl("Structure",      { fg = c.cyan })
  hl("Typedef",        { fg = c.cyan })

  hl("Special",        { fg = c.cyan })
  hl("SpecialChar",    { fg = c.orange })
  hl("Delimiter",      { fg = p.dim })
  hl("SpecialComment", { fg = c.cyan })
  hl("Tag",            { fg = c.blue })

  hl("Title",          { fg = c.blue, bold = true })
  hl("Todo",           { fg = c.yellow, bold = true })

  -- diff (the :diffthis / fugitive surface — distinct from gutter chrome)
  hl("DiffAdd",        { fg = c.green })
  hl("DiffChange",     { fg = c.yellow })
  hl("DiffDelete",     { fg = c.red })
  hl("DiffText",       { fg = c.orange, bold = true })
  hl("Added",          { fg = c.green })
  hl("Changed",        { fg = c.yellow })
  hl("Removed",        { fg = c.red })

  -- ── Vivid content syntax (treesitter @-captures) ──────────────────────
  -- Modern nvim highlights via treesitter for most languages (.rs, .lua,
  -- .toml, etc.). These @-captures must get the vivid accents too or the
  -- legacy mapping above never reaches treesitter-highlighted buffers.
  hl("@comment",                 { fg = p.comment, italic = true })

  hl("@keyword",                 { fg = c.magenta })
  hl("@keyword.function",        { fg = c.magenta })
  hl("@keyword.operator",        { fg = c.magenta })
  hl("@keyword.return",          { fg = c.magenta })
  hl("@keyword.conditional",     { fg = c.magenta })
  hl("@keyword.repeat",          { fg = c.magenta })
  hl("@keyword.import",          { fg = c.magenta })
  hl("@keyword.exception",       { fg = c.magenta })
  hl("@conditional",             { fg = c.magenta })
  hl("@repeat",                  { fg = c.magenta })
  hl("@exception",               { fg = c.magenta })
  hl("@include",                 { fg = c.magenta })

  hl("@string",                  { fg = c.green })
  hl("@string.regex",            { fg = c.cyan })
  hl("@string.escape",           { fg = c.orange })
  hl("@string.special",          { fg = c.orange })
  hl("@character",               { fg = c.green })
  hl("@character.special",       { fg = c.orange })

  hl("@number",                  { fg = c.orange })
  hl("@number.float",            { fg = c.orange })
  hl("@float",                   { fg = c.orange })
  hl("@boolean",                 { fg = c.orange })
  hl("@constant",                { fg = c.orange })
  hl("@constant.builtin",        { fg = c.orange })
  hl("@constant.macro",          { fg = c.cyan })

  hl("@function",                { fg = c.blue })
  hl("@function.call",           { fg = c.blue })
  hl("@function.builtin",        { fg = c.blue_dk })
  hl("@function.macro",          { fg = c.cyan })
  hl("@function.method",         { fg = c.blue })
  hl("@function.method.call",    { fg = c.blue })
  hl("@constructor",             { fg = c.cyan })
  hl("@method",                  { fg = c.blue })
  hl("@method.call",             { fg = c.blue })

  hl("@type",                    { fg = c.cyan })
  hl("@type.builtin",            { fg = c.cyan })
  hl("@type.definition",         { fg = c.cyan })
  hl("@type.qualifier",          { fg = c.magenta })
  hl("@storageclass",            { fg = c.cyan })
  hl("@attribute",               { fg = c.cyan })
  hl("@namespace",               { fg = c.blue_dk })
  hl("@module",                  { fg = c.blue_dk })

  hl("@variable",                { fg = p.fg })
  hl("@variable.builtin",        { fg = c.red })
  hl("@variable.parameter",      { fg = c.orange })
  hl("@variable.member",         { fg = p.fg })
  hl("@parameter",               { fg = c.orange })
  hl("@field",                   { fg = p.fg })
  hl("@property",                { fg = p.fg })

  hl("@operator",                { fg = c.cyan })
  hl("@punctuation.delimiter",   { fg = p.dim })
  hl("@punctuation.bracket",     { fg = p.dim })
  hl("@punctuation.special",     { fg = c.orange })

  hl("@label",                   { fg = c.magenta })
  hl("@tag",                     { fg = c.magenta })
  hl("@tag.attribute",           { fg = c.cyan })
  hl("@tag.delimiter",           { fg = p.dim })

  hl("@text.title",              { fg = c.blue, bold = true })
  hl("@text.uri",                { fg = c.cyan, underline = true })
  hl("@text.literal",           { fg = c.green })
  hl("@text.reference",          { fg = c.orange })
  hl("@text.todo",               { fg = c.yellow, bold = true })
  hl("@text.warning",            { fg = c.yellow })
  hl("@text.danger",             { fg = c.red })

  -- nvim 0.10+ semantic-token / treesitter normalized names
  hl("@markup.heading",          { fg = c.blue, bold = true })
  hl("@markup.link.url",         { fg = c.cyan, underline = true })
  hl("@markup.raw",              { fg = c.green })
  hl("@markup.list",             { fg = c.magenta })
  hl("@diff.plus",               { fg = c.green })
  hl("@diff.minus",              { fg = c.red })
  hl("@diff.delta",              { fg = c.yellow })

  -- LSP semantic tokens — align with the treesitter accents above so LSP
  -- and treesitter never disagree on the same token.
  hl("@lsp.type.keyword",        { fg = c.magenta })
  hl("@lsp.type.function",       { fg = c.blue })
  hl("@lsp.type.method",         { fg = c.blue })
  hl("@lsp.type.type",           { fg = c.cyan })
  hl("@lsp.type.struct",         { fg = c.cyan })
  hl("@lsp.type.enum",           { fg = c.cyan })
  hl("@lsp.type.interface",      { fg = c.cyan })
  hl("@lsp.type.class",          { fg = c.yellow })
  hl("@lsp.type.namespace",      { fg = c.blue_dk })
  hl("@lsp.type.parameter",      { fg = c.orange })
  hl("@lsp.type.property",       { fg = p.fg })
  hl("@lsp.type.variable",       { fg = p.fg })
  hl("@lsp.type.string",         { fg = c.green })
  hl("@lsp.type.number",         { fg = c.orange })
  hl("@lsp.type.enumMember",     { fg = c.orange })

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
