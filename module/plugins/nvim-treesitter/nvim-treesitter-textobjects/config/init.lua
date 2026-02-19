local M = {}
function M.setup()
  require("nvim-treesitter.configs").setup({
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "outer function" },
          ["if"] = { query = "@function.inner", desc = "inner function" },
          ["ac"] = { query = "@class.outer", desc = "outer class" },
          ["ic"] = { query = "@class.inner", desc = "inner class" },
          ["aa"] = { query = "@parameter.outer", desc = "outer argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = { query = "@function.outer", desc = "Next function start" },
        },
        goto_next_end = {
          ["]M"] = { query = "@function.outer", desc = "Next function end" },
        },
        goto_previous_start = {
          ["[m"] = { query = "@function.outer", desc = "Previous function start" },
        },
        goto_previous_end = {
          ["[M"] = { query = "@function.outer", desc = "Previous function end" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
        },
        swap_previous = {
          ["<leader>A"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
        },
      },
    },
  })
end
return M
