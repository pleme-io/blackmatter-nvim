local M = {}
function M.setup()
  local has_illuminate, illuminate = pcall(require, "illuminate")
  if not has_illuminate then return end

  illuminate.configure({
    delay = 200,
    min_count_to_highlight = 2,
    filetypes_denylist = {
      "NvimTree",
      "lazy",
      "mason",
      "trouble",
    },
  })
end
return M
