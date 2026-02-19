local M = {}
function M.setup()
	-- skip nvim-treesitter integration module (deprecated)
	vim.g.skip_ts_context_commentstring_module = true
	-- Enable ts-context-commentstring to update `commentstring` based on cursor context
	require("ts_context_commentstring").setup({ enable_autocmd = false })
	-- Optional: custom commentstring for specific filetypes
	require("ts_context_commentstring.internal").filetype_commentstring = {
		["yaml.helm"] = "{{/* %s */}}",
	}
end
return M
