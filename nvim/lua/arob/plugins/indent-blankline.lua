vim.opt.list = true

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#2A273D gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#534D80 gui=nocombine]])

require("indent_blankline").setup({
	strict_tabs = false,
	indent_blankline_use_treesitter = true,
	show_first_indent_level = true,
	show_current_context_start = false,
	indentLine_enabled = 1,
	buftype_exclude = { "terminal" },

	char_highlight_list = {
		"IndentBlanklineIndent1",
	},

	show_current_context = true,
	context_highlight_list = {
		"IndentBlanklineIndent2",
	},

	filetype_exclude = {
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
})
