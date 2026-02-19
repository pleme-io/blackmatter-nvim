-- Uses Neovim 0.11 native vim.lsp.config / vim.lsp.enable API
local M = {}

function M.setup()
	-- Setup Mason (for UI/management, not installation)
	local has_mason, mason = pcall(require, "mason")
	if has_mason then
		mason.setup()
	end

	-- Global capabilities: apply cmp_nvim_lsp to all servers
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if has_cmp_lsp then
		capabilities = cmp_lsp.default_capabilities(capabilities)
	end
	vim.lsp.config("*", { capabilities = capabilities })

	-- Per-server overrides from nix_managed_servers.lua
	local nix_servers = require("groups.lsp.nix_managed_servers")
	local server_names = {}

	for server, server_config in pairs(nix_servers) do
		-- Extract on_attach for LspAttach autocmd (vim.lsp.config doesn't support it)
		local on_attach = server_config.on_attach
		server_config.on_attach = nil

		local ok, err = pcall(function()
			vim.lsp.config(server, server_config)
		end)
		if ok then
			table.insert(server_names, server)
		else
			vim.notify("[LSP] Error configuring " .. server .. ": " .. err, vim.log.levels.ERROR)
		end

		-- Register per-server on_attach via LspAttach autocmd
		if on_attach then
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == server then
						on_attach(client, args.buf)
					end
				end,
			})
		end
	end

	-- Enable all configured servers
	vim.lsp.enable(server_names)

	-- Setup filetypes
	require("groups.lsp.filetypes").setup()

	-- Enhanced LSP UI
	require("groups.lsp.diagnostics").setup()
	require("groups.lsp.lspsaga").setup()
	require("groups.lsp.keybindings").setup()

	-- vim-illuminate, trouble, and tiny-inline-diagnostic self-configure via configDir
end

return M
