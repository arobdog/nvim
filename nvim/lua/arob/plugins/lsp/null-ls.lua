-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		--  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
		formatting.prettier, -- js/ts formatter
		formatting.black, -- python
		formatting.stylua, -- lua formatter
		diagnostics.eslint_d.with({
			condition = function(utils)
				-- Check for all common ESLint config files and tsconfig.json
				local has_eslint_config = utils.root_has_file({
					".eslintrc",
					".eslintrc.json",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					"eslint.config.js",
					"tsconfig.json",
				})

				if not has_eslint_config then
					return false
				end

				-- If tsconfig.json exists, check if it includes ESLint configurations
				if utils.root_has_file("tsconfig.json") then
					local tsconfig = utils.read_file("tsconfig.json")
					if tsconfig and tsconfig:match('"extends"%s*:%s*".*eslint') then
						return true
					end
				end

				-- Return true if any other ESLint config file is present
				return has_eslint_config
			end,
		}),
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
