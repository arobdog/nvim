-- Import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- For conciseness
local formatting = null_ls.builtins.formatting
local eslint_d_ok, eslint_d = pcall(require, "none-ls.diagnostics.eslint_d")

-- To setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Define the path to the Neovim-specific .prettierrc
local nvim_prettier_config = vim.fn.stdpath("config") .. "/.prettierrc"

-- Function to check if a local Prettier config exists in the project
local function has_local_prettier_config(params)
	local root = params.root or vim.fn.getcwd()
	for _, name in ipairs({
		".prettierrc", ".prettierrc.json", ".prettierrc.js",
		".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.toml",
		"prettier.config.js", "prettier.config.cjs",
	}) do
		if vim.fn.filereadable(root .. "/" .. name) == 1 then
			return true
		end
	end
	return false
end

-- Configure null-ls
null_ls.setup({
	sources = {
		-- Prettier for JS/TS, HTML, CSS, etc., with plugin support
		formatting.prettier.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"html",
				"css",
				"scss",
				"less",
				"json",
				"jsonc",
				"markdown",
				"markdown.mdx",
			},
			extra_args = function(params)
				local args = {}

				-- Only use Neovim’s .prettierrc if no local config exists and it’s readable
				if not has_local_prettier_config(params) and vim.fn.filereadable(nvim_prettier_config) == 1 then
					table.insert(args, "--config")
					table.insert(args, nvim_prettier_config)
				end

				return args
			end,
		}),
		-- Black for Python
		formatting.black,
		-- Stylua for Lua
		formatting.stylua,
		-- ESLint for diagnostics
		eslint_d_ok and eslint_d.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			condition = function(utils)
				return utils.root_has_file({
					".eslintrc",
					".eslintrc.json",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					"eslint.config.js",
					"eslint.config.mjs",
				})
			end,
		}) or nil,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.scss", "*.json", "*.md" },
	callback = function(args)
		vim.lsp.buf.format({
			filter = function(c)
				return c.name == "null-ls"
			end,
			bufnr = args.buf,
			async = false,
		})
	end,
})
