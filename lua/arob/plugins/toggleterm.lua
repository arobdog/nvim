local setup, toggleterm = pcall(require, "toggleterm")
if not setup then
	return
end

toggleterm.setup({
	size = 15,
	open_mapping = [[<c-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shadingfactor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		boader = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-t><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-t><C-n>]], opts)
	vim.keymap.set("t", "<C-Left>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-Down>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-Up>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-Right>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-t><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
