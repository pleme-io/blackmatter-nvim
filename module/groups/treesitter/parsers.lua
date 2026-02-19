-- Parsers path helper (legacy — not currently required by the primary flow)
-- Nix symlinks parsers to ~/.local/share/nvim/site/parser/ which is
-- already on the default runtimepath. No manual path setup needed.
local M = {}
function M.get_parsers_path()
	return vim.fn.stdpath("data") .. "/site"
end
return M
