local M = {}
function M.setup()
  local has_gitsigns, gitsigns = pcall(require, "gitsigns")
  if not has_gitsigns then return end

  gitsigns.setup({
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "▁" },
      topdelete    = { text = "▔" },
      changedelete = { text = "▎" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
      virt_text_pos = "eol",
    },
    sign_priority = 6,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Hunk navigation
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous hunk" })

      -- Hunk actions
      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
      map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })

      -- Hunk text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
    end,
  })

  -- Sign colors from the ACTIVE palette so they follow the FLEET_THEME
  -- selector (classic Nord by default, warm Vellum when FLEET_THEME=vellum).
  -- cterm twins keep signs colored without truecolor.
  local p = require("groups.theming.colorscheme").palette
  vim.api.nvim_set_hl(0, "GitSignsAdd",          { fg = p.green.gui,  ctermfg = p.green.cterm })
  vim.api.nvim_set_hl(0, "GitSignsChange",       { fg = p.yellow.gui, ctermfg = p.yellow.cterm })
  vim.api.nvim_set_hl(0, "GitSignsDelete",       { fg = p.red.gui,    ctermfg = p.red.cterm })
  vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = p.purple.gui, ctermfg = p.purple.cterm })
  vim.api.nvim_set_hl(0, "GitSignsTopdelete",    { fg = p.red.gui,    ctermfg = p.red.cterm })
end
return M
