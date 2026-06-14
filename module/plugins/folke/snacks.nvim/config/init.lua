local M = {}
function M.setup()
  local Snacks = require("snacks")

  -- Gradient ASCII logo. The gradient follows the FLEET_THEME selector owned
  -- by groups.theming.colorscheme:
  --   nord   (default) — vivid Nord aurora-green (#A3BE8C) → frost-cyan
  --                      (#88C0D0), matching the ghostty Nord screenshot.
  --   vellum           — warm Vellum cyan (#94BBB8) → green (#A9BB8C) (saved).
  -- Rendered via terminal section for ANSI color support + cascade animation.
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

  -- nord:   vivid Nord green #A3BE8C (163,190,140) → frost cyan #88C0D0 (136,192,208)
  -- vellum: warm cyan #94BBB8 (148,187,184) → green #A9BB8C (169,187,140)
  local gradient_nord = {
    { 163, 190, 140 }, { 158, 190, 154 }, { 152, 191, 167 },
    { 147, 191, 181 }, { 141, 192, 194 }, { 136, 192, 208 },
    nil, -- empty line
    { 163, 190, 140 }, { 158, 190, 154 }, { 152, 191, 167 },
    { 147, 191, 181 }, { 141, 192, 194 }, { 136, 192, 208 },
  }
  local gradient_vellum = {
    { 148, 187, 184 }, { 152, 187, 175 }, { 156, 187, 166 },
    { 160, 187, 157 }, { 164, 187, 149 }, { 169, 187, 140 },
    nil, -- empty line
    { 148, 187, 184 }, { 152, 187, 175 }, { 156, 187, 166 },
    { 160, 187, 157 }, { 164, 187, 149 }, { 169, 187, 140 },
  }
  local gradient = (fleet_theme == "vellum") and gradient_vellum or gradient_nord

  local parts = {}
  for i, line in ipairs(logo) do
    if line == "" then
      parts[#parts + 1] = "echo ''"
    else
      local c = gradient[i]
      parts[#parts + 1] = string.format(
        [[printf '\033[38;2;%d;%d;%dm'; echo '%s'; sleep 0.015]],
        c[1], c[2], c[3], line
      )
    end
  end
  -- Tagline + separator follow the theme:
  --   nord   — separator Nord border #4C566A (76,86,106), tagline snow #D8DEE9 (216,222,233)
  --   vellum — separator border #6E6857 (110,104,87), tagline dim #ADA593 (173,165,147)
  local sep_rgb, tag_rgb
  if fleet_theme == "vellum" then
    sep_rgb, tag_rgb = { 110, 104, 87 }, { 173, 165, 147 }
  else
    sep_rgb, tag_rgb = { 76, 86, 106 }, { 216, 222, 233 }
  end
  parts[#parts + 1] = "echo ''"
  parts[#parts + 1] = string.format(
    [[printf '\033[38;2;%d;%d;%dm'; echo '              ─────────────────────────────']],
    sep_rgb[1], sep_rgb[2], sep_rgb[3]
  )
  parts[#parts + 1] = string.format(
    [[printf '\033[38;2;%d;%d;%dm'; echo '                    neovim, refined']],
    tag_rgb[1], tag_rgb[2], tag_rgb[3]
  )
  parts[#parts + 1] = [[printf '\033[0m']]
  local logo_cmd = table.concat(parts, "; ")

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
        { section = "terminal", cmd = logo_cmd, height = 16, padding = 2 },
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
