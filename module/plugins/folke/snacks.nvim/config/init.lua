local M = {}
function M.setup()
  local Snacks = require("snacks")

  -- Gradient ASCII logo: Vellum cyan (#94BBB8) → Vellum green (#A9BB8C)
  -- Rendered via terminal section for ANSI color support + cascade animation
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

  -- Vellum cyan #94BBB8 (148,187,184) → Vellum green #A9BB8C (169,187,140)
  local gradient = {
    { 148, 187, 184 }, { 152, 187, 175 }, { 156, 187, 166 },
    { 160, 187, 157 }, { 164, 187, 149 }, { 169, 187, 140 },
    nil, -- empty line
    { 148, 187, 184 }, { 152, 187, 175 }, { 156, 187, 166 },
    { 160, 187, 157 }, { 164, 187, 149 }, { 169, 187, 140 },
  }

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
  -- Tagline in Vellum dim (#ADA593) with breathing room; separator in border (#6E6857)
  parts[#parts + 1] = "echo ''"
  parts[#parts + 1] = [[printf '\033[38;2;110;104;87m'; echo '              ─────────────────────────────']]
  parts[#parts + 1] = [[printf '\033[38;2;173;165;147m'; echo '                    neovim, refined']]
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
