-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		mappings = {
			i = {
				["<C-e>"] = actions.move_selection_previous, -- move to prev result
				["<C-i>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
		layout_strategy = "flex",
	},
	pickers = {
		find_files = {
			layout_config = {
				flip_columns = 180,
				-- flip_lines = 100,
				vertical = {
					anchor = "top",
					height = 0.9,
					width = 0.75,
					preview_height = 0.7,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
				horizontal = {
					anchor = "top",
					height = 0.9,
					width = 0.85,
					preview_width = 0.65,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
			},
		},
		grep_string = {
			layout_config = {
				flip_columns = 180,
				--flip_lines = 100,
				vertical = {
					anchor = "top",
					height = 0.9,
					width = 0.75,
					preview_height = 0.7,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
				horizontal = {
					anchor = "top",
					height = 0.9,
					width = 0.85,
					preview_width = 0.65,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
			},
		},
		live_grep = {
			layout_config = {
				flip_columns = 180,
				--flip_lines = 100,
				vertical = {
					anchor = "top",
					height = 0.9,
					width = 0.75,
					preview_height = 0.7,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
				horizontal = {
					anchor = "top",
					height = 0.9,
					width = 0.85,
					preview_width = 0.65,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

telescope.load_extension("fzf")
