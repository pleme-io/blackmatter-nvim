local M = {}
function M.get()
	return {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "cmdline" },
		{ name = "path" },
		{ name = "treesitter" },
	}
end
return M
