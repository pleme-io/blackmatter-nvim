local M = {}

function M.setup()
	-- Server configurations are loaded via servers.lua
	-- Note: config/ directory contents are flattened to plugins/neovim/nvim-lspconfig/
	require("plugins.neovim.nvim-lspconfig.servers")
end

return M
