local M = {}
function M.setup_helm_filetype()
  vim.api.nvim_create_augroup("HelmFiletype", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = "HelmFiletype",
    pattern = { "*/charts/*/templates/*.{yaml,yml,tpl}", "*.tpl" },
    callback = function()
      vim.bo.filetype = "yaml.helm"
    end,
  })
end
return M
