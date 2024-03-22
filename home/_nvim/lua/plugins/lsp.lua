return {
	-- { "fatih/vim-go" },
	{
		"fatih/vim-go",
		config = function ()
		  -- we disable most of these features because treesitter and nvim-lsp
		  -- take care of it
		  vim.g['go_gopls_enabled'] = 0
		  vim.g['go_code_completion_enabled'] = 0
		  vim.g['go_fmt_autosave'] = 0
		  vim.g['go_imports_autosave'] = 0
		  vim.g['go_mod_fmt_autosave'] = 0
		  vim.g['go_doc_keywordprg_enabled'] = 0
		  vim.g['go_def_mapping_enabled'] = 0
		  vim.g['go_textobj_enabled'] = 0
		  vim.g['go_list_type'] = 'quickfix'
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"gopls"
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities
			})
			lspconfig.tsserver.setup({
				capabilities = capabilities
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				-- gocoverage_sign = "│",
				-- from https://github.com/fatih/dotfiles/blob/main/init.lua
				flags = { debounce_text_changes = 200 },
				gocoverage_sign = "█",
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						gofumpt = true,
						analyses = {
							nilness = true,
							unusedparams = true,
							unusedwrite = true,
              				useany = true,
						},
						codelenses = {
							gc_details = false,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						  },
						  experimentalPostfixCompletions = true,
						  completeUnimported = true,
						  staticcheck = true,
						  directoryFilters = { "-.git", "-node_modules" },
						  semanticTokens = true,
						  hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						  },
					}
				}
			})

			-- Default handlers for LSPl
			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}
			-- See `:help K` for why this keymap
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation" })
			vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation" })
			vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "LSP: [G]oto [S]ignature Documentation" })
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "LSP: [G]oto [T]ype Definition" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration" })
			vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame" })
			vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction" })
			vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, { desc = "LSP: [G]oto [I]mplementation" })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "LSP: [G]oto [R]eferences" })
			vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = "LSP: [C]ode [L]ens" })
		end,
	},
}
