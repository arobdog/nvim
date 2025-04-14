local line_ok, feline = pcall(require, "feline")

if not line_ok then
	return
end

local rose_pine = {
	bg = "#191724",
	fg = "#908caa",
	nc = "#16141f",
	base = "#191724",
	surface = "#1f1d2e",
	overlay = "#26233a",
	muted = "#6e6a86",
	subtle = "#908caa",
	text = "#e0def4",
	love = "#eb6f92",
	gold = "#f6c177",
	rose = "#ebbcba",
	pine = "#31748f",
	foam = "#9ccfd8",
	iris = "#c4a7e7",
}

local vi_mode_colors = {
	NORMAL = rose_pine.iris,
	OP = rose_pine.iris,
	INSERT = rose_pine.foam,
	VISUAL = rose_pine.love,
	LINES = rose_pine.gold,
	BLOCK = rose_pine.love,
	REPLACE = rose_pine.foam,
	COMMAND = rose_pine.gold,
	TERM = rose_pine.pine,
}

local c = {
	vim_mode = {
		provider = {
			name = "vi_mode",
			opts = {
				show_mode_name = true,
				-- padding = "center", -- Uncomment for extra padding.
			},
		},
		hl = function()
			return {
				fg = require("feline.providers.vi_mode").get_mode_color(),
				bg = "bg",
				style = "bold",
				name = "NeovimModeHLColor",
			}
		end,
		left_sep = "block",
		right_sep = "block",
	},
	gitBranch = {
		provider = "git_branch",
		hl = {
			fg = "pine",
			bg = "bg",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
	fileinfo = {
		provider = {
			name = "file_info",
			opts = {
				type = "relative",
			},
		},
		short_provider = {
			name = "file_info",
			opts = {
				type = "short-path",
			},
		},
		hl = {
			style = "NONE",
		},
		left_sep = " ",
		right_sep = " ",
	},
	separator = {
		provider = "",
	},
	lsp_client_names = {
		provider = "lsp_client_names",
		hl = {
			fg = "fg",
			bg = "bg",
			style = "bold",
		},
		left_sep = "left_filled",
		right_sep = "block",
	},
	file_type = {
		provider = {
			name = "file_type",
			opts = {
				filetype_icon = true,
				case = "titlecase",
			},
		},
		hl = {
			fg = "fg",
			bg = "bg",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
	file_encoding = {
		provider = "file_encoding",
		hl = {
			fg = "fg",
			bg = "bg",
			style = "italic",
		},
		left_sep = "block",
		right_sep = "block",
	},
	position = {
		provider = "position",
		hl = {
			fg = "fg",
			bg = "bg",
			style = "NONE",
		},
		left_sep = "block",
		right_sep = "block",
	},
	line_percentage = {
		provider = "line_percentage",
		hl = {
			fg = "fg",
			bg = "bg",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
}

local left = {
	c.vim_mode,
	c.gitBranch,
	c.fileinfo,
	c.separator,
}

local middle = {}

local right = {
	c.file_type,
	c.position,
	c.line_percentage,
}

local components = {
	active = {
		left,
		middle,
		right,
	},
	inactive = {
		left,
		middle,
		right,
	},
}

feline.setup({
	components = components,
	theme = rose_pine,
	vi_mode_colors = vi_mode_colors,
})
