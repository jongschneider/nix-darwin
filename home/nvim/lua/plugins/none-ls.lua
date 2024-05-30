return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- null_ls.builtins.code_actions.gomodifytags,
				-- null_ls.builtins.code_actions.impl,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.gofumpt,
				-- null_ls.builtins.formatting.golines,
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.diagnostics.rubocop,
			},
		})
	end,
}
