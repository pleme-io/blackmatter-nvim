-- plugins/williamboman/mason.nvim/config/init.lua
-- ============================================================================
-- NOTE: This config is not currently loaded via the plugin system.
-- LSP setup is handled in groups/lsp/init.lua which:
-- 1. Calls mason.setup() directly for the UI
-- 2. Configures servers from groups/lsp/nix_managed_servers.lua
-- ============================================================================
local M = {}

function M.setup()
	require("mason").setup()
end

return M
