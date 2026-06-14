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

  -- Vellum highlight colors (cterm twins so signs stay colored without truecolor)
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#A9BB8C", ctermfg = 144 })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#D7C489", ctermfg = 180 })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#C9837B", ctermfg = 174 })
  vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#B8A1B9", ctermfg = 139 })
  vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#C9837B", ctermfg = 174 })
end
return M
