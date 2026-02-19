local M = {}
function M.setup()
	-- load theme fundamentals first
	-- Note: Fixed author name from muni to MunifTanjim
	require("plugins.MunifTanjim.nui-nvim").setup()

	-- Lazy-loaded plugins setup themselves via config callbacks
	-- Only setup non-lazy plugins here
	require("groups.theming.colorscheme").setup()
	require("plugins.nvim-tree.nvim-web-devicons").setup()

	-- These are lazy-loaded and self-configure via configDir:
	-- - plugins.folke.noice-nvim
	-- - plugins.folke.snacks-nvim
	-- - plugins.akinsho.bufferline-nvim (delegates to groups.theming.bufferline)
	-- - plugins.nvim-lualine.lualine-nvim (delegates to groups.theming.lualine)
	-- - plugins.lewis6991.gitsigns-nvim (delegates to groups.theming.gitsigns)
	-- - plugins.lukas-reineke.indent-blankline-nvim (delegates to groups.theming.indent-blankline)
end
return M
