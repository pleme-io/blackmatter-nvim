local M = {}
function M.setup()
  local actions = require("telescope.actions")

  require("telescope").setup({
    defaults = {
      layout_strategy = "horizontal",
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      path_display = { "truncate" },
      file_ignore_patterns = { "node_modules", ".git/", "build/", "dist/", "target/" },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob", "!.git/*",
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-v>"] = actions.select_vertical,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        },
        n = {
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        },
      },
      preview = {
        treesitter = true,
      },
    },
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
      },
    },
  })
end
return M
