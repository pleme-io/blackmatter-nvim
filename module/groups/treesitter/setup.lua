-- nvim-treesitter setup (old configs API — pinned to master branch)
-- This file is an alternative entry point; the primary flow goes through
-- groups/treesitter/init.lua → plugins/nvim-treesitter/nvim-treesitter/config/init.lua
local M = {}
function M.setup()
	-- Parsers are Nix-managed at ~/.local/share/nvim/site/parser/
	-- which matches the default parser_install_dir. No explicit path needed.
	require("nvim-treesitter.configs").setup({
		ensure_installed = {},
		auto_install = false,
		highlight = {
			enable = true,
			disable = { "nix" },
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
	})
end
return M
