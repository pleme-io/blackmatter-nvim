local M = {}
function M.setup()
  local Snacks = require("snacks")

  -- Gradient ASCII logo. The gradient follows the FLEET_THEME selector owned
  -- by groups.theming.colorscheme:
  --   nord   (default) — vivid Nord aurora-green (#A3BE8C) → frost-cyan
  --                      (#88C0D0), matching the ghostty Nord screenshot.
  --   vellum           — warm Vellum cyan (#94BBB8) → green (#A9BB8C) (saved).
  -- Rendered with nvim highlight groups (a `text` section), not a shell cmd.
  local fleet_theme = (function()
    local ok, cs = pcall(require, "groups.theming.colorscheme")
    if ok and cs.theme then return cs.theme end
    return (vim.env.FLEET_THEME ~= nil and vim.env.FLEET_THEME ~= "" and vim.env.FLEET_THEME) or "nord"
  end)()

  local logo = {
    "    ██████╗ ██╗      █████╗  ██████╗██╗  ██╗",
    "    ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝",
    "    ██████╔╝██║     ███████║██║     █████╔╝ ",
    "    ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ",
    "    ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗",
    "    ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝",
    "",
    "    ███╗   ███╗ █████╗ ████████╗████████╗███████╗██████╗ ",
    "    ████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗",
    "    ██╔████╔██║███████║   ██║      ██║   █████╗  ██████╔╝",
    "    ██║╚██╔╝██║██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗",
    "    ██║ ╚═╝ ██║██║  ██║   ██║      ██║   ███████╗██║  ██║",
    "    ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝",
  }

  -- 6-stop green→cyan gradient per theme, applied as nvim HIGHLIGHT GROUPS
  -- (gui colors) — NOT a shell `printf` cmd. The old `section = "terminal"`
  -- approach ran `printf '\033[38;2;..m'; echo; sleep` through nvim's &shell
  -- (= frostmourne in mado), which never rendered the BLACK MATTER block in
  -- mado (frostmourne rc-load / printf timing). Highlight groups are pure
  -- nvim: no shell, no printf, no sleep — identical + reliable in mado AND
  -- ghostty, and they honor termguicolors directly (no SGR round-trip).
  local grad_hex = (fleet_theme == "vellum")
    and { "#94BBB8", "#98BBAF", "#9CBBA6", "#A0BB9D", "#A4BB94", "#A9BB8C" }
    or  { "#A3BE8C", "#9EBE9A", "#98BFA7", "#93BFB5", "#8DC0C2", "#88C0D0" }
  -- Separator + tagline per theme (Nord border/snow | Vellum border/dim).
  local sep_hex = (fleet_theme == "vellum") and "#6E6857" or "#4C566A"
  local tag_hex = (fleet_theme == "vellum") and "#ADA593" or "#D8DEE9"
  -- Set the logo highlight groups AND re-set them on every ColorScheme:
  -- the base `:colorscheme nord` does `hi clear`, which would wipe these
  -- custom groups if the dashboard happened to configure before the
  -- colorscheme. The autocmd makes the logo colors survive any (re)load.
  local function set_logo_hl()
    for i, hex in ipairs(grad_hex) do
      vim.api.nvim_set_hl(0, "MadoDashLogo" .. i, { fg = hex, bold = true })
    end
    vim.api.nvim_set_hl(0, "MadoDashSep", { fg = sep_hex })
    vim.api.nvim_set_hl(0, "MadoDashTag", { fg = tag_hex, bold = true })
  end
  set_logo_hl()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = set_logo_hl })

  -- The 13 logo lines map onto the 6 gradient stops (each half spans the
  -- full gradient; the blank line between the words gets no highlight).
  local grad_for = { 1, 2, 3, 4, 5, 6, nil, 1, 2, 3, 4, 5, 6 }
  local logo_text = {}
  for i, line in ipairs(logo) do
    if line == "" then
      logo_text[#logo_text + 1] = { "\n" }
    else
      logo_text[#logo_text + 1] = { line .. "\n", hl = "MadoDashLogo" .. grad_for[i] }
    end
  end
  logo_text[#logo_text + 1] = { "\n" }
  logo_text[#logo_text + 1] = { "    ─────────────────────────────\n", hl = "MadoDashSep" }
  logo_text[#logo_text + 1] = { "          neovim, refined\n", hl = "MadoDashTag" }

  Snacks.setup({
    notifications = { enabled = true, timeout = 3000 },
    input = { enabled = true },
    select = { enabled = true },
    quickfix = { enabled = true },
    commandline = { enabled = true },
    gitbrowse = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
    scroll = { enabled = true },
    zen = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "t", desc = "Run Tests", action = ":Neotest summary" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "text", text = logo_text, padding = 2 },
        { section = "keys", gap = 1, padding = 2 },
        { section = "recent_files", title = "Recent Files", icon = " ", limit = 8, padding = 2 },
        { section = "startup" },
      },
    },
  })

  -- Keybindings
  vim.keymap.set("n", "<leader>gg", function() Snacks.gitbrowse() end, { desc = "Open in GitHub" })
  vim.keymap.set("n", "<leader>tt", function() Snacks.terminal() end, { desc = "Toggle terminal" })
  vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen mode" })
  vim.keymap.set("n", "]]", function() Snacks.words.jump(1) end, { desc = "Next reference" })
  vim.keymap.set("n", "[[", function() Snacks.words.jump(-1) end, { desc = "Previous reference" })
end
return M
