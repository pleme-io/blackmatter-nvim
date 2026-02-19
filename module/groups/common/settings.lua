local M = {}
function M.setup()
	vim.opt.wildignore:append("**/node_modules/*")
	vim.opt.wildignore:append("**/.git/*")
	vim.opt.wildignore:append("**/build/*")
	vim.opt.wildignorecase = true
	vim.opt.hlsearch = true
	vim.opt.number = true
	vim.opt.signcolumn = "yes"
	vim.opt.cursorline = true
	vim.opt.scrolloff = 8
	vim.opt.wrap = false
	vim.opt.updatetime = 300
	vim.opt.relativenumber = true
	vim.opt.termguicolors = true
	vim.opt.timeoutlen = 300
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true
	vim.opt.tabstop = 2
	-- mapleader set in init.lua before lazy.nvim loads
	vim.opt.path:remove("/usr/include")
	vim.opt.path:append("**")
	vim.cmd([[set path=.,,,$PWD/**]])
	vim.opt.showtabline = 0
	vim.opt.breakindent = true
	vim.opt.swapfile = false
  vim.opt.clipboard = "unnamedplus"
  vim.g.loaded_perl_provider   = 0
  vim.g.loaded_ruby_provider   = 0
	-- recognize rust-script as rust
	vim.filetype.add({
		pattern = {
			[".*%.ers"] = "rust",
		},
	})
	-- Diagnostic config managed by groups.lsp.diagnostics
end
return M
