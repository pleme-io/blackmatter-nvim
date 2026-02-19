-- Enhanced LSP UI via lspsaga
local M = {}

function M.setup()
	local has_saga, lspsaga = pcall(require, "lspsaga")
	if not has_saga then
		vim.notify("[LSP] lspsaga not found, skipping UI enhancements", vim.log.levels.WARN)
		return
	end

	lspsaga.setup({
		-- General UI
		ui = {
			border = "rounded",
			title = true,
			winblend = 0,
			expand = "",
			collapse = "",
			code_action = "󰌵",
			actionfix = " ",
			imp_sign = "󰳛 ",
			kind = {},
		},

		-- Hover documentation
		hover = {
			max_width = 0.6,
			max_height = 0.6,
			open_link = "gx",
			open_cmd = "!open",
		},

		-- Code actions
		code_action = {
			num_shortcut = true,
			show_server_name = true,
			extend_gitsigns = false,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},

		-- Lightbulb in gutter when code actions available
		lightbulb = {
			enable = true,
			sign = true,
			virtual_text = false,
			debounce = 10,
			sign_priority = 40,
		},

		-- Diagnostic display
		diagnostic = {
			show_code_action = true,
			show_layout = "float",
			show_normal_height = 10,
			jump_num_shortcut = true,
			max_width = 0.8,
			max_height = 0.6,
			text_hl_follow = true,
			border_follow = true,
			diagnostic_only_current = false,
			keys = {
				exec_action = "o",
				quit = "q",
				toggle_or_jump = "<CR>",
				quit_in_show = { "q", "<ESC>" },
			},
		},

		-- Inline rename
		rename = {
			in_select = true,
			auto_save = false,
			keys = {
				quit = "<C-c>",
				exec = "<CR>",
			},
		},

		-- Breadcrumbs in winbar (disabled — too noisy)
		symbol_in_winbar = {
			enable = false,
		},

		-- Symbols outline sidebar
		outline = {
			win_position = "right",
			win_width = 30,
			auto_preview = true,
			detail = true,
			auto_close = true,
			close_after_jump = false,
			layout = "normal",
			keys = {
				toggle_or_jump = "o",
				quit = "q",
				jump = "e",
			},
		},

		-- Definition/reference finder
		finder = {
			max_height = 0.5,
			left_width = 0.3,
			right_width = 0.3,
			default = "ref+imp",
			layout = "float",
			silent = false,
			keys = {
				shuttle = "[w",
				toggle_or_open = "o",
				vsplit = "s",
				split = "i",
				tabe = "t",
				quit = "q",
				close = "<C-c>k",
			},
		},

		-- Implementation signs
		implement = {
			enable = true,
			sign = true,
			virtual_text = true,
			priority = 100,
		},

		-- Peek definition
		definition = {
			width = 0.6,
			height = 0.5,
			keys = {
				edit = "<C-o>",
				vsplit = "<C-v>",
				split = "<C-x>",
				tabe = "<C-t>",
				quit = "q",
				close = "<C-c>",
			},
		},

		-- Call hierarchy
		callhierarchy = {
			layout = "float",
			keys = {
				edit = "e",
				vsplit = "s",
				split = "i",
				tabe = "t",
				close = "<C-c>k",
				quit = "q",
				shuttle = "[w",
				toggle_or_req = "u",
			},
		},
	})
end

return M
