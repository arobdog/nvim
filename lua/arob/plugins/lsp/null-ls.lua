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

-- Configure null-ls
null_ls.setup({
	sources = {
		-- Prettier for JS/TS, HTML, CSS, etc., with Tailwind CSS support
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
			extra_args = {
				-- Ensure prettier-plugin-tailwindcss is used if installed
				"--plugin-search-dir=.",
			},
		}),
		-- Black for Python
		formatting.black,
		-- Stylua for Lua
		formatting.stylua,
		-- ESLint for diagnostics, with refined conditions
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
