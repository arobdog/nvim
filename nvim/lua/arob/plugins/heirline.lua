local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colours = require("arob.core.themes.rose-pine")

local Align = { provider = "%=", hl = { bg = colours.statusline_bg } }
local Space = { provider = " ", hl = { bg = colours.statusline_bg } }

local ViMode = {
	-- get vim current mode, this information will be required by the provider
	-- and the highlight functions, so we compute it only once per component
	-- evaluation and store it as a component attribute
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	-- Now we define some dictionaries to map the output of mode() to the
	-- corresponding string and color. We can put these into `static` to compute
	-- them at initialisation time.
	static = {
		mode_names = { -- change the strings if you like it vvvvverbose!
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
		mode_colors = {
			n = colours.iris,
			i = colours.foam,
			v = colours.love,
			V = colours.love,
			["\22"] = colours.love,
			c = colours.gold,
			s = colours.rose,
			S = colours.rose,
			["\19"] = colours.love,
			R = colours.gold,
			r = colours.gold,
			["!"] = colours.love,
			t = colours.love,
		},
	},
	-- We can now access the value of mode() that, by now, would have been
	-- computed by `init()` and use it to index our strings dictionary.
	-- note how `static` fields become just regular attributes once the
	-- component is instantiated.
	-- To be extra meticulous, we can also add some vim statusline syntax to
	-- control the padding and make sure our string is always at least 2
	-- characters long. Plus a nice Icon.
	provider = function(self)
		return " %2(" .. self.mode_names[self.mode] .. "%)"
	end,
	-- Same goes for the highlight. Now the foreground will change according to the current mode.
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return { fg = self.mode_colors[mode], bg = colours.highlight_med, bold = true }
	end,
	-- Re-evaluate the component only on ModeChanged event!
	-- Also allows the statusline to be re-evaluated when entering operator-pending mode
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}
-- We can now define some children separately and add them later

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color, bg = colours.statusline_bg }
	end,
}

local FileName = {
	provider = function(self)
		-- first, trim the pattern relative to the current directory. For other
		-- options, see :h filename-modifers
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then
			return "[No Name]"
		end
		-- now, if the filename would occupy more than 1/4th of the available
		-- space, we trim the file path to its initials
		-- See Flexible Components section below for dynamic truncation
		if not conditions.width_percent_below(#filename, 0.45) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
	hl = { fg = colours.fg, bg = colours.statusline_bg, bold = false },
}

local FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " ● ",
		hl = { fg = colours.foam, bg = colours.statusline_bg },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "  ",
		hl = { fg = colours.gold, bg = colours.statusline_bg },
	},
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			-- use `force` because we need to override the child's hl foreground
			return { fg = colours.foam, bold = false, force = true }
		end
	end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
	FileNameBlock,
	FileIcon,
	utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
	FileFlags,
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
	condition = function()
		return conditions.width_percent_below(4, 0.045)
	end,
	provider = function()
		return string.upper(vim.bo.filetype)
	end,
	hl = { fg = colours.pine, bg = colours.statusline_bg, bold = false },
}

local FileEncoding = {
	provider = function()
		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
		return enc ~= "utf-8" and enc:upper()
	end,
}

local FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		return fmt ~= "unix" and fmt:upper()
	end,
}

-- We're getting minimalists here!
local Ruler = {
	condition = function()
		return conditions.width_percent_below(4, 0.095)
	end,
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- %c = column number
	-- %P = percentage through file of displayed window
	provider = "%l:%2c",
	hl = { fg = colours.iris, bg = colours.statusline_bg },
}

local ScrollPercentage = {
	condition = function()
		return conditions.width_percent_below(4, 0.095)
	end,
	-- %P  : percentage through file of displayed window
	provider = " %3(%P%) ",
	hl = { fg = colours.gold, bg = colours.statusline_bg, bold = false },
}

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	hl = { fg = colours.rose, bg = colours.statusline_bg, bold = false },

	{ -- git branch name
		condition = function()
			return conditions.width_percent_below(4, 0.055)
		end,
		provider = function(self)
			return " " .. self.status_dict.head
		end,
		hl = { bold = false },
	},
	-- You could handle delimiters, icons and counts similar to Diagnostics
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = " ",
	},
	{
		condition = function()
			return conditions.width_percent_below(4, 0.055)
		end,
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("+" .. count)
		end,
		hl = { fg = colours.pine },
	},
	{
		condition = function()
			return conditions.width_percent_below(4, 0.055)
		end,
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("-" .. count)
		end,
		hl = { fg = colours.love },
	},
	{
		condition = function()
			return conditions.width_percent_below(4, 0.055)
		end,
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("~" .. count)
		end,
		hl = { fg = colours.gold },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = "",
	},
}

local LSPActive = {
	condition = conditions.lsp_attached,
	update = { "LspAttach", "LspDetach" },

	hl = { bg = colours.statusline_bg },

	-- Or complicate things a bit and get the servers names
	{
		condition = function()
			return conditions.width_percent_below(4, 0.045)
		end,
		provider = function()
			local names = {}
			for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
				table.insert(names, server.name)
			end
			return " " .. names[1]
		end,
		hl = { fg = colours.pine, bg = colours.statusline_bg, bold = false },
	},
}

ViMode = utils.surround({ "", "" }, colours.highlight_med, { ViMode })

require("heirline").setup({
	statusline = {
		ViMode,
		Space,
		Space,
		FileNameBlock,
		Space,
		Align,
		Git,
		Space,
		Space,
		LSPActive,
		Space,
		Space,
		Ruler,
		Space,
		ScrollPercentage,
	},
	options = { colors = colours },
})
