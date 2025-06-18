-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#9ccfd8 ]])

-- configure nvim-tree
nvimtree.setup({
	-- change folder arrow icons
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "▸",
					arrow_open = "▾",
					--arrow_closed = "→",
					--arrow_open = "↓",
					--arrow_closed = "▶",
					--arrow_open = "▼",
				},
			},
			show = {
				git = true,
			},
		},
		highlight_git = true,
	},
	sort = {
		sorter = "case_sensitive",
	},
	git = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},
	filters = {
		git_ignored = false,
		dotfiles = false,
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	view = {
		width = 25, -- Set the sidebar width to 25 characters
		preserve_window_proportions = true,
	},
	update_cwd = true,
	sync_root_with_cwd = true,
})

-- open nvim-tree on setup

local function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not no_name and not directory then
		return
	end

	-- change to the directory
	if directory then
		vim.cmd.cd(data.file)
	end

	-- open the tree
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
