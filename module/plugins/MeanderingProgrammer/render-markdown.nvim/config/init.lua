-- Render Markdown - Beautiful in-buffer markdown rendering
local M = {}

function M.setup()
  require("render-markdown").setup({
    -- Nord-themed heading colors
    headings = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    highlights = {
      heading = {
        backgrounds = { "NordFrost1", "NordFrost2", "NordFrost3", "NordFrost1", "NordFrost2", "NordFrost3" },
        foregrounds = { "NordSnow1", "NordSnow1", "NordSnow1", "NordSnow1", "NordSnow1", "NordSnow1" },
      },
      code = "NordPolar1",
    },
    code = {
      enabled = true,
      sign = true,
      style = "normal", -- Can be: "full", "normal", "language", "none"
      left_pad = 2,
      right_pad = 2,
    },
    dash = "─",
    bullets = { "●", "○", "◆", "◇" },
    quote = "▎",
    checkbox = {
      unchecked = " ",
      checked = " ",
    },
  })
end

return M
