-- Import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- Import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap -- for conciseness

-- Enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- Keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- go to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic
	keymap.set("n", "gt", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- toggle outline

	-- TypeScript-specific keymaps for typescript-tools.nvim
	if client.name == "typescript-tools" then
		keymap.set("n", "<leader>rf", "<cmd>TSToolsRenameFile<CR>", opts) -- rename file
		keymap.set("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<CR>", opts) -- organize imports
		keymap.set("n", "<leader>ru", "<cmd>TSToolsRemoveUnusedImports<CR>", opts) -- remove unused imports
	end
end

-- Used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Configure typescript server with typescript-tools.nvim
require("typescript-tools").setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		tsserver_file_preferences = {
			includeInlayParameterNameHints = "all",
			includeCompletionsForModuleExports = true,
		},
	},
})

-- Configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					"tw\\.[\\w-]+", -- Support `tw.xxx`
					"tw\\([\\w-]+\\)", -- Support `tw(xxx)`
					"className\\s*[:=]\\s*['\"][^'\"]*['\"]", -- Match className
				},
			},
		},
	},
})

-- Configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
})

-- Configure lua server
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- Configure rust server
lspconfig["rust_analyzer"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Configure eslint (optional, integrated with null-ls)
lspconfig["eslint"].setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	settings = {
		packageManager = "npm", -- Changed to npm for broader compatibility
	},
})
