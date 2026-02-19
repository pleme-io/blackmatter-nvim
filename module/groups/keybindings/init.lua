local M = {}

function M.setup()
	-- Format file via conform
	vim.keymap.set("n", "ff", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { noremap = true, silent = true, desc = "Format file" })

	-- Buffer navigation (bufferline integration)
	vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
	vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
	vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })

	-- Clear search highlight
	vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

	-- Move lines up/down
	vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
	vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
	vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
	vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

	-- Save file
	vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

	-- Splits
	vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
	vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })

	-- Quick escape from insert mode
	vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape to normal mode" })
end

return M
