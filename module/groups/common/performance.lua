
local M = {}
function M.setup()
	-- Disable built-in vim plugins to improve startup time
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_gzip = 1
	vim.g.loaded_tar = 1
	vim.g.loaded_tarPlugin = 1
	vim.g.loaded_zip = 1
	vim.g.loaded_zipPlugin = 1
	vim.g.loaded_getscript = 1
	vim.g.loaded_getscriptPlugin = 1
	vim.g.loaded_vimball = 1
	vim.g.loaded_vimballPlugin = 1
	vim.g.loaded_matchit = 1
	vim.g.loaded_matchparen = 1
	vim.g.loaded_2html_plugin = 1
	vim.g.loaded_logipat = 1
	vim.g.loaded_rrhelper = 1
	vim.g.loaded_shada_plugin = 1

	-- Enable shellslash on Windows or WSL environments
	local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
	local in_wsl = vim.env.WSL_DISTRO_NAME ~= nil
	if is_win or in_wsl then
		vim.opt.shellslash = true
	end
end

return M
