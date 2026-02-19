-- Diagnostic signs, display config, and signature help
local M = {}

function M.setup()
	-- Enhanced diagnostic display
	-- virtual_text disabled in favor of tiny-inline-diagnostic.nvim
	vim.diagnostic.config({
		virtual_text = false,
		-- Nerd Font diagnostic signs (Neovim 0.11+ API, replaces deprecated sign_define)
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.HINT] = "󰌵 ",
				[vim.diagnostic.severity.INFO] = " ",
			},
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = function(diagnostic)
				local icons = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰌵 ",
					[vim.diagnostic.severity.INFO] = " ",
				}
				return icons[diagnostic.severity] or "● ", "Diagnostic" .. ({
					[vim.diagnostic.severity.ERROR] = "Error",
					[vim.diagnostic.severity.WARN] = "Warn",
					[vim.diagnostic.severity.HINT] = "Hint",
					[vim.diagnostic.severity.INFO] = "Info",
				})[diagnostic.severity]
			end,
		},
	})

	-- lsp_signature: floating signature help while typing
	local has_sig, lsp_signature = pcall(require, "lsp_signature")
	if has_sig then
		lsp_signature.setup({
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			hint_enable = true,
			hint_prefix = "󰏪 ",
			hint_scheme = "Comment",
			floating_window = true,
			floating_window_above_cur_line = true,
			max_height = 12,
			max_width = 80,
			toggle_key = "<C-k>",
			select_signature_key = "<C-n>",
		})
	end
end

return M
