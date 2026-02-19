
-- Set mapleader BEFORE loading lazy.nvim
vim.g.mapleader = ","

-- Skip deprecated nvim-treesitter context_commentstring module
-- Must be set BEFORE lazy.nvim loads plugins
vim.g.skip_ts_context_commentstring_module = true

-- Add jsregexp to Lua cpath for LuaSnip transformations (Nix-managed path)
pcall(require, "luasnip-jsregexp-path")

-- Use Nix-provided Python with latest pynvim
-- This is set via NVIM_PYTHON3_HOST_PROG environment variable from home-manager
-- but we set it here as a fallback
if vim.env.NVIM_PYTHON3_HOST_PROG then
	vim.g.python3_host_prog = vim.env.NVIM_PYTHON3_HOST_PROG
end

-- Filter out "not installed" messages for disabled plugins
local notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Suppress "Plugin X is not installed" messages
  if type(msg) == "string" and msg:match("Plugin .* is not installed") then
    return
  end
  notify(msg, level, opts)
end

-- Bootstrap lazy.nvim
-- Plugins are installed via Nix, lazy.nvim handles runtime loading
local lazypath = vim.fn.stdpath("data") .. "/site/pack/folke/start/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with Nix-installed plugins
require("lazy").setup("lazy-plugins", {
  defaults = {
    lazy = false,  -- Let individual plugin specs control lazy loading
  },
  performance = {
    -- Reset packpath so lazy.nvim doesn't warn about Nix-managed pack/ dirs
    reset_packpath = false,
    rtp = {
      -- Don't reset rtp — Nix adds pack paths we need
      reset = false,
      -- Disable built-in Vim plugins we don't use
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
  -- Don't check for updates (Nix manages versions)
  checker = { enabled = false },
  -- Don't clone plugins (Nix installs them)
  install = { missing = false },
  -- Suppress "not installed" messages for disabled plugins
  change_detection = {
    notify = false,
  },
})

-- Core settings that don't depend on plugins
require("groups.common").setup()

-- Setup non-lazy plugins immediately
-- Lazy plugins will setup themselves when they load (via their config callback)
require("groups.treesitter").setup()
require("groups.lsp").setup()

-- These can setup immediately since most of their plugins aren't lazy
-- Lazy ones (bufferline, lualine, etc.) will re-setup when they load
require("groups.theming").setup()
require("plugins.stevearc.conform-nvim").setup()
require("groups.keybindings").setup()
require("groups.completion").setup()
