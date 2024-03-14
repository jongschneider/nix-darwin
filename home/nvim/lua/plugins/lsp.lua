return {
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
				capabilities = capabilities
			})
			-- See `:help K` for why this keymap
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation" })
			vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation" })
			vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "LSP: [G]oto [S]ignature Documentation" })
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "LSP: [G]oto [T]ype Definition" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: [G]oto [I]mplementation" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: [G]oto [R]eferences" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration" })
			vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame" })
			vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction" })
		end,
	},
}
