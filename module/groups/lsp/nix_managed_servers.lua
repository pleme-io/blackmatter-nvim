-- ============================================================================
-- NIX-MANAGED LANGUAGE SERVERS (single source of truth)
-- ============================================================================
-- Each entry maps a server name to its lspconfig configuration.
-- Use {} for default config, or provide settings/on_attach/etc.
--
-- To add a new server:
-- 1. Install the server package in groups/lsp/default.nix (home.packages)
-- 2. Add an entry here: server_name = { ...config... }
-- 3. Rebuild
-- ============================================================================

return {
	basedpyright = {
		settings = {
			basedpyright = {
				analysis = {
					typeCheckingMode = "standard",
				},
			},
		},
	},
	ruff = {
		-- Match basedpyright's UTF-16 encoding to avoid position encoding mismatch warning
		capabilities = {
			general = {
				positionEncodings = { "utf-16" },
			},
		},
	},
	ts_ls = {},
	nixd = {
		on_attach = function(_, _)
			vim.lsp.handlers["textDocument/didSave"] = function(...) end
		end,
		settings = {
			nixd = {
				options = {
					nixpkgs = {
						expr = "import <nixpkgs> {}",
					},
				},
			},
		},
	},
	rust_analyzer = {},
	ruby_lsp = {},
	bashls = {
		settings = {
			bashIde = {
				shellcheckPath = "shellcheck",
			},
		},
	},
	nushell = {},
	zls = {},
	gopls = {},
	clangd = {
		cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
	},
	-- powershell_es disabled: powershell-editor-services not available in nixpkgs-unstable
}
