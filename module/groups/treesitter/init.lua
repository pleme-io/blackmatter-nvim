local M = {}
function M.setup()
	-- Setup context-commentstring BEFORE treesitter to avoid deprecation warning
	-- This sets vim.g.skip_ts_context_commentstring_module = true
	require("plugins.JoosepAlviste.nvim-ts-context-commentstring").setup()

	local filetype = require("groups.treesitter.filetype")
	filetype.setup_helm_filetype()

	-- Parsers (.so) and queries (.scm) are Nix-managed at ~/.local/share/nvim/site/
	-- which matches the old nvim-treesitter default parser_install_dir.
	-- No explicit parsers_path needed — nil uses the correct default.
	require("plugins.nvim-treesitter.nvim-treesitter").setup()

	-- render-markdown.nvim: lazy-loaded on ft=markdown, configures itself via plugin config
end
return M
