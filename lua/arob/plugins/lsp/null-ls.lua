-- Import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- For conciseness
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- To setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Define the path to the Neovim-specific .prettierrc
local nvim_prettier_config = vim.fn.stdpath("config") .. "/.prettierrc"

-- Function to check if a local Prettier config exists in the project
local function has_local_prettier_config(utils)
	return utils.root_has_file({
		".prettierrc",
		".prettierrc.json",
		".prettierrc.js",
		".prettierrc.yaml",
		".prettierrc.yml",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
		"package.json", -- Assumes it may contain a "prettier" field
	})
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
				-- Always include plugin search directory for local plugins
				local args = { "--plugin-search-dir=." }

				-- Only use Neovim's .prettierrc if no local config exists and it’s readable
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
		diagnostics.eslint_d.with({
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
		}),
	},
	-- Format on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(c)
							return c.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
