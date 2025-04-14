vim.opt.list = true

-- Define custom highlights for indent lines and context
vim.cmd([[highlight IndentBlanklineIndent1 guifg=#2A273D gui=nocombine]])
vim.cmd([[highlight IndentBlanklineContextChar guifg=#534D80 gui=nocombine]])

require("ibl").setup({
	indent = {
		char = "│", -- Character for indent lines (optional, matches default)
		highlight = { "IndentBlanklineIndent1" }, -- Highlight for indent lines
	},
	scope = {
		enabled = true, -- Show current context (replaces show_current_context)
		show_start = false, -- Don’t show context start line (matches show_current_context_start = false)
		highlight = { "IndentBlanklineContextChar" }, -- Highlight for context
	},
	exclude = {
		filetypes = {
			"help",
			"terminal",
			"lazy",
			"lspinfo",
			"TelescopePrompt",
			"TelescopeResults",
			"mason",
			"nvdash",
			"nvcheatsheet",
			"",
		},
		buftypes = { "terminal" },
	},
})
