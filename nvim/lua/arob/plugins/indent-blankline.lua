-- Set list mode to show special characters like tabs and trailing spaces
vim.opt.list = true

-- Define custom highlights for indent lines
vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#2A273D", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#534D80", nocombine = true })

-- Set up the `ibl` plugin with custom configurations
require("ibl").setup({
	indent = {
		char = "▏", -- or any other character you want to use
		highlight = { "IndentBlanklineIndent1" },
	},
	scope = {
		enabled = true, -- Enables scope highlighting
		highlight = "IndentBlanklineIndent2", -- Uses the same highlight group for scope
	},
})
