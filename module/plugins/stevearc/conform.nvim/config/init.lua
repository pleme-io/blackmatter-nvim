local M = {}

-- Helper to check if a command exists
local function cmd_exists(cmd)
	return vim.fn.executable(cmd) == 1
end

function M.setup()
	-- Build formatters_by_ft dynamically based on available tools
	local formatters_by_ft = {}

	-- Always available via Nix
	formatters_by_ft.nix = { "alejandra" }
	formatters_by_ft.lua = { "stylua" }
	formatters_by_ft.rust = { "rustfmt" }
	formatters_by_ft.toml = { "taplo" }
	formatters_by_ft.sh = { "shfmt" }
	formatters_by_ft.zsh = { "shfmt" }
	formatters_by_ft.php = { "php_cs_fixer" }
	formatters_by_ft.ruby = { "rubocop" }
	formatters_by_ft.java = { "google-java-format" }

	-- Prettier-based formats
	if cmd_exists("prettier") then
		formatters_by_ft.typescript = { "prettier" }
		formatters_by_ft.javascript = { "prettier" }
		formatters_by_ft.markdown = { "prettier" }
		formatters_by_ft.yaml = { "prettier" }
		formatters_by_ft.json = { "prettier" }
		formatters_by_ft.html = { "prettier" }
	end

	-- Python
	if cmd_exists("black") then
		formatters_by_ft.python = { "black" }
	end

	-- Go (prefer gofumpt over gofmt)
	if cmd_exists("gofumpt") then
		formatters_by_ft.go = { "gofumpt" }
	elseif cmd_exists("gofmt") then
		formatters_by_ft.go = { "gofmt" }
	end

	-- Protocol Buffers
	if cmd_exists("buf") then
		formatters_by_ft.proto = { "buf" }
	end

	-- Optional formatters (may not be installed)
	if cmd_exists("terraform") then
		formatters_by_ft.terraform = { "terraform_fmt" }
		formatters_by_ft["terraform-vars"] = { "terraform_fmt" }
		formatters_by_ft.tf = { "terraform_fmt" }
	end

	if cmd_exists("zig") then
		formatters_by_ft.zig = { "zigfmt" }
	end

	if cmd_exists("latexindent") then
		formatters_by_ft.tex = { "latexindent" }
	end

	if cmd_exists("swift-format") then
		formatters_by_ft.swift = { "swift_format" }
	end

	require("conform").setup({
		formatters = {
			buf = {
				command = "buf",
				args = { "format", "--path", "$FILENAME" },
				stdin = false,
			},
			zigfmt = {
				command = "zig",
				args = { "fmt", "--stdin" },
				stdin = true,
			},
			gofumpt = {
				command = "gofumpt",
				stdin = true,
			},
			latexindent = {
				command = "latexindent",
				args = { "-" },
				stdin = true,
			},
			-- rustfmt with edition detection
			rustfmt = {
				command = "rustfmt",
				args = { "--edition", "2021" },
				stdin = true,
			},
		},
		formatters_by_ft = formatters_by_ft,
		-- Format on save with reasonable timeouts
		format_on_save = function(bufnr)
			-- Longer timeout for Rust (can be slow on large files)
			local timeout = 500
			local ft = vim.bo[bufnr].filetype
			if ft == "rust" then
				timeout = 2000
			end
			return {
				timeout_ms = timeout,
				lsp_fallback = true,
			}
		end,
	})
end

return M
