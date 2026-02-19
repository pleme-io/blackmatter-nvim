local M = {}
function M.setup()
	-- Ensure undo directory exists
	local undodir = vim.fn.stdpath("cache") .. "/undo"
	if vim.fn.isdirectory(undodir) == 0 then
		vim.fn.mkdir(undodir, "p")
	end

	-- Persistent undo
	vim.opt.undofile = true
	vim.opt.undodir = undodir

	-- Disable swap/backup files
	vim.opt.backup = false
	vim.opt.writebackup = false
end
return M
