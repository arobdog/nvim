-- nvim-treesitter (main branch) configuration.
-- The main branch dropped the old `require("nvim-treesitter.configs").setup{}` API:
-- there is no `ensure_installed`/`highlight.enable`/`indent` table anymore. Instead we
-- install parsers explicitly and turn on highlighting + indentation per buffer.
local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	return
end

-- Parsers to keep installed. `install()` is async and a no-op for parsers already
-- present, so it's safe to run on every startup. Parsers land in ~/.local/share/nvim/site/parser.
local ensure_installed = {
	"json",
	"javascript",
	"typescript",
	"tsx",
	"rust",
	"python",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"yaml",
	"html",
	"css",
	"markdown",
	"markdown_inline",
	"graphql",
	"bash",
	"lua",
	"vim",
	"vimdoc",
	"dockerfile",
	"gitignore",
	"terraform",
	"hcl",
}

ts.install(ensure_installed)

-- Enable treesitter highlighting + indentation per buffer. On the main branch this is
-- done with vim.treesitter.start() rather than a global `highlight.enable`. We guard with
-- pcall so buffers whose parser isn't installed (yet) just fall back to no highlighting
-- instead of erroring.
local ts_group = vim.api.nvim_create_augroup("ArobTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = ts_group,
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		-- vim.treesitter.start loads the parser and errors if none is installed for `lang`.
		if not pcall(vim.treesitter.start, buf, lang) then
			return
		end
		-- Treesitter-based indentation (experimental on the main branch).
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
