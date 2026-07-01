-- Native LSP configuration (Neovim 0.11+ `vim.lsp.config` / `vim.lsp.enable` API).
-- nvim-lspconfig is kept installed only for its bundled server definitions under
-- `lsp/*.lua` (cmd, root markers, default filetypes), which Neovim discovers on the
-- runtimepath. We no longer use its deprecated `require("lspconfig")` framework.

-- Import cmp-nvim-lsp plugin safely (for completion capabilities)
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap -- for conciseness

-- Buffer-local keybinds, applied whenever a server attaches.
local function on_attach(client, bufnr)
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

-- terraform-ls warns ("Ignoring workspace folder (unsupported or invalid URI)...
-- This is most likely bug, please report it.") when it's told about a non-file URI
-- workspace folder — e.g. the diffview:// buffers diffview.nvim opens for .tf files.
-- It already ignores the bad folder, so this is harmless noise; drop just that message.
local function suppress_workspace_folder_warning(handler)
	return function(err, result, ctx, config)
		if result and type(result.message) == "string" and result.message:find("Ignoring workspace folder", 1, true) then
			return
		end
		if handler then
			return handler(err, result, ctx, config)
		end
	end
end

-- Change the Diagnostic symbols in the sign column
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Defaults shared by every server. Per-server configs below merge on top of this
-- (and on top of nvim-lspconfig's bundled definitions).
vim.lsp.config("*", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- TypeScript via typescript-tools.nvim (not an nvim-lspconfig server)
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

-- tailwindcss: narrow the filetypes and add custom class regexes
vim.lsp.config("tailwindcss", {
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

-- emmet language server: broaden to the markup/style filetypes we use
vim.lsp.config("emmet_ls", {
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
})

-- lua language server: teach it about the `vim` global and the runtime/config libs
vim.lsp.config("lua_ls", {
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

-- Run gopls "organize imports" code action (goimports-style) on the buffer
local function go_organize_imports(client, bufnr, timeout_ms)
	local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeout_ms)
	for _, res in pairs(result or {}) do
		for _, action in pairs(res.result or {}) do
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
			end
		end
	end
end

-- go server (gopls handles gofumpt formatting + goimports)
vim.lsp.config("gopls", {
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)

		-- Inlay hints on by default for Go, with a toggle
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			keymap.set("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
			end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle inlay hints" })
		end

		-- Format (gofumpt) + organize imports on save
		local go_augroup = vim.api.nvim_create_augroup("GoFormatting", { clear = false })
		vim.api.nvim_clear_autocmds({ group = go_augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = go_augroup,
			buffer = bufnr,
			callback = function()
				go_organize_imports(client, bufnr, 1000)
				vim.lsp.buf.format({ bufnr = bufnr, async = false })
			end,
		})
	end,
	settings = {
		gopls = {
			gofumpt = true, -- stricter gofmt
			staticcheck = true, -- extra static analysis in-editor
			usePlaceholders = true, -- fill function signatures on completion
			completeUnimported = true, -- autocomplete symbols from un-imported packages
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				nilness = true,
				shadow = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

-- OpenTofu files aren't detected by default; treat them like terraform (.tf opens as "terraform")
vim.filetype.add({
	extension = { tofu = "terraform" },
	pattern = { [".*%.tofu%.json"] = "json" },
})

-- terraform / opentofu server (handles .tf and .tofu; formats via `terraform fmt`)
vim.lsp.config("terraformls", {
	-- .tf resolves to filetype "tf" on recent Neovim, so list it explicitly
	filetypes = { "terraform", "tf", "terraform-vars" },
	handlers = {
		["window/showMessage"] = suppress_workspace_folder_warning(vim.lsp.handlers["window/showMessage"]),
		["window/logMessage"] = suppress_workspace_folder_warning(vim.lsp.handlers["window/logMessage"]),
	},
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)

		local tf_augroup = vim.api.nvim_create_augroup("TerraformFormatting", { clear = false })
		vim.api.nvim_clear_autocmds({ group = tf_augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = tf_augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr, async = false })
			end,
		})
	end,
})

-- tflint language server (Terraform / OpenTofu linting, live diagnostics)
vim.lsp.config("tflint", {
	filetypes = { "terraform", "tf" },
})

-- eslint (optional, integrated with null-ls); fix all on save
vim.lsp.config("eslint", {
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

-- Enable the nvim-lspconfig-backed servers (typescript-tools enables itself above).
vim.lsp.enable({
	"html",
	"cssls",
	"tailwindcss",
	"emmet_ls",
	"lua_ls",
	"rust_analyzer",
	"gopls",
	"terraformls",
	"tflint",
	"eslint",
})
