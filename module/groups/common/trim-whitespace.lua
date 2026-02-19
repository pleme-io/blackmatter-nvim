local M = {}
function M.setup()
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function()
			vim.cmd([[%s/\s\+$//e]])
		end,
	})
end
return M
