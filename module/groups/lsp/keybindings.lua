-- LSP keybindings using lspsaga for enhanced UI
local M = {}

function M.setup()
	local map = vim.keymap.set
	local opts = { noremap = true, silent = true }

	-- Only bind lspsaga keys if it's available
	local has_saga = pcall(require, "lspsaga")
	if not has_saga then
		return
	end

	-- Hover documentation
	map("n", "K", "<cmd>Lspsaga hover_doc<CR>", vim.tbl_extend("force", opts, { desc = "Hover doc" }))

	-- Code actions
	map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", vim.tbl_extend("force", opts, { desc = "Code action" }))

	-- Rename
	map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
	map("n", "<leader>rN", "<cmd>Lspsaga rename ++project<CR>", vim.tbl_extend("force", opts, { desc = "Rename (project-wide)" }))

	-- Go to definition
	map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", vim.tbl_extend("force", opts, { desc = "Go to definition" }))
	map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", vim.tbl_extend("force", opts, { desc = "Peek definition" }))

	-- Go to type definition
	map("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
	map("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", vim.tbl_extend("force", opts, { desc = "Peek type definition" }))

	-- References and finder
	map("n", "gr", "<cmd>Lspsaga finder<CR>", vim.tbl_extend("force", opts, { desc = "Find references + implementations" }))

	-- Diagnostic navigation
	map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
	map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
	map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "Cursor diagnostics" }))
	map("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))

	-- Outline
	map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", vim.tbl_extend("force", opts, { desc = "Toggle symbol outline" }))

	-- Call hierarchy
	map("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", vim.tbl_extend("force", opts, { desc = "Incoming calls" }))
	map("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", vim.tbl_extend("force", opts, { desc = "Outgoing calls" }))

	-- Trouble keybindings are defined in the plugin's lazy spec (plugins/folke/trouble.nvim/default.nix)
end

return M
