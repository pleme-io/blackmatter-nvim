local M = {}
function M.setup()
  require("lualine").setup({
    options = {
      theme              = "nord",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      icons_enabled      = true,
      globalstatus       = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        "diagnostics",
      },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
      },
      lualine_x = {
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        },
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return " " .. table.concat(names, ", ")
          end,
        },
        { "filetype", icon_only = false },
      },
      lualine_y = { "searchcount", "selectioncount", "progress" },
      lualine_z = { "location" },
    },
  })
end
return M
