local M = {}
function M.setup(parsers_path)
	require("nvim-treesitter.configs").setup({
		-- context_commentstring is set up separately via nvim-ts-context-commentstring
		parser_install_dir = parsers_path,
		-- Parsers are provided by Nix, so don't auto-install
		ensure_installed = {},
		auto_install = false,
		highlight = {
			enable = true,
			disable = { "nix" },
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
	})
end
return M
