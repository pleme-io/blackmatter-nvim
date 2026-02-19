-- Blackmatter Neovim - Standalone package init.lua
-- Paths are injected by Nix via substitute

-- Set mapleader BEFORE loading lazy.nvim
vim.g.mapleader = ","

-- Skip deprecated nvim-treesitter context_commentstring module
vim.g.skip_ts_context_commentstring_module = true

-- Add config/lua to Lua search path
local config_dir = "@configDir@"
package.path = config_dir .. "/lua/?.lua;" .. config_dir .. "/lua/?/init.lua;" .. package.path

-- Add store-provided data to neovim rtp (parsers, queries)
local pack_dir = "@packDir@"
vim.opt.rtp:append(pack_dir)

-- Add jsregexp to Lua cpath for LuaSnip transformations (Nix-managed path)
pcall(require, "luasnip-jsregexp-path")

-- Use Nix-provided Python with latest pynvim
if vim.env.NVIM_PYTHON3_HOST_PROG then
	vim.g.python3_host_prog = vim.env.NVIM_PYTHON3_HOST_PROG
end

-- Filter out "not installed" messages for disabled plugins
local notify = vim.notify
vim.notify = function(msg, level, opts)
	if type(msg) == "string" and msg:match("Plugin .* is not installed") then
		return
	end
	notify(msg, level, opts)
end

-- Bootstrap lazy.nvim from Nix store
local lazypath = pack_dir .. "/pack/folke/start/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Load lazy-plugins (returns a table with Nix store paths for dir)
local plugins = require("lazy-plugins")
require("lazy").setup(plugins, {
	defaults = {
		lazy = false,
	},
	performance = {
		reset_packpath = false,
		rtp = {
			reset = false,
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	checker = { enabled = false },
	install = { missing = false },
	change_detection = {
		notify = false,
	},
})

-- Core settings that don't depend on plugins
require("groups.common").setup()

-- Setup non-lazy plugins immediately
require("groups.treesitter").setup()
require("groups.lsp").setup()

-- Theming, formatting, keybindings, completion
require("groups.theming").setup()
require("plugins.stevearc.conform-nvim").setup()
require("groups.keybindings").setup()
require("groups.completion").setup()

-- User customization: source ~/.config/blnvim/lua/user/init.lua if it exists
local user_config = vim.fn.stdpath("config") .. "/lua"
package.path = user_config .. "/?.lua;" .. user_config .. "/?/init.lua;" .. package.path
pcall(require, "user")
