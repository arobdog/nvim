vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>")
vim.keymap.set("n", "<leader>dx", "<cmd>DiffviewClose<CR>")

vim.g.minimap_git_colors = 1

require("diffview").setup({
	file_panel = {
		win_config = {
			width = 25,
		},
	},
})
