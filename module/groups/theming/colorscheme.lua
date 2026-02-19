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
