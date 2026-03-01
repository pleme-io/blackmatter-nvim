local M = {}
function M.setup()
  -- set your colorscheme early so other plugins pick up its highlights
  vim.cmd([[colorscheme nord]])
  -- expose your palette for others
  M.base   = "#2E3440"
  M.popout = "#d8dee9"

  -- rounded borders on all floating windows (Neovim 0.11+)
  vim.o.winborder = "rounded"

  -- subtle float and cursor highlights
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4C566A", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2E3440" })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3B4252" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#88C0D0", bold = true })

  -- search highlights — frost accent on polar night
  vim.api.nvim_set_hl(0, "Search", { fg = "#2E3440", bg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = "#2E3440", bg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "CurSearch", { fg = "#2E3440", bg = "#A3BE8C" })

  -- visual selection — slightly lighter than CursorLine for distinction
  vim.api.nvim_set_hl(0, "Visual", { bg = "#434C5E" })
  vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#434C5E" })

  -- treesitter-context — sticky scope header
  vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#313745" })
  vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#3B4252", bg = "#313745" })

  -- line numbers — subdued, let code take focus
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#4C566A" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#4C566A", bg = "NONE" })

  -- window separators — thin, barely there
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3B4252" })

  -- completion menu — cohesive with floats
  vim.api.nvim_set_hl(0, "Pmenu", { fg = "#D8DEE9", bg = "#2E3440" })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#ECEFF4", bg = "#3B4252" })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#3B4252" })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#4C566A" })

  -- diagnostics — explicit aurora mapping
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#BF616A" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#A3BE8C" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#BF616A" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#88C0D0" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#A3BE8C" })

  -- matching brackets — frost accent, not neon
  vim.api.nvim_set_hl(0, "MatchParen", { fg = "#88C0D0", bg = "#434C5E", bold = true })

  -- word highlighting (vim-illuminate) — subtle same-word emphasis
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3B4252" })
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3B4252" })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3B4252", underline = true })

  -- folds — muted, out of the way
  vim.api.nvim_set_hl(0, "Folded", { fg = "#616E88", bg = "#313745" })

  -- invisible characters — nearly invisible
  vim.api.nvim_set_hl(0, "NonText", { fg = "#3B4252" })
  vim.api.nvim_set_hl(0, "Whitespace", { fg = "#3B4252" })

  -- telescope — recessed borders, frost accents on titles
  vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#3B4252" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#4C566A" })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#3B4252" })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#3B4252" })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#88C0D0", bold = true })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#A3BE8C" })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#81A1C1" })
  vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#3B4252" })
  vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#88C0D0" })

  -- git blame — italic, recedes into background
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#4C566A", italic = true })

  -- floating window titles — consistent accent
  vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#88C0D0", bold = true })

  -- completion match highlighting — frost accent on matched characters
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#88C0D0", bold = true })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#4C566A", strikethrough = true })
  vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#81A1C1" })
  vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#81A1C1" })
  vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#81A1C1" })
  vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#A3BE8C" })
  vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#B48EAD" })
  vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#D08770" })
  vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#D8DEE9" })
  vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#D8DEE9" })
  vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#D8DEE9" })

  -- notifications — severity-colored borders and icons
  vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#BF616A" })
  vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#4C566A" })
  vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#B48EAD" })
  vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#BF616A" })
  vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#4C566A" })
  vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#B48EAD" })
  vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#BF616A" })
  vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = "#88C0D0" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#4C566A" })
  vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#B48EAD" })

  -- trouble — custom window styling
  vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "#2E3440" })
  vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "#2E3440" })
  vim.api.nvim_set_hl(0, "TroubleCount", { fg = "#88C0D0", bold = true })
  vim.api.nvim_set_hl(0, "TroubleIndent", { fg = "#3B4252" })

  -- lsp signature active parameter — stand out in param list
  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "#EBCB8B", bold = true, underline = true })

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
