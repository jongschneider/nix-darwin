return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = true,
		format_on_save = {
			-- async = true,
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			javascript = { "prettierd", "prettier", stop_after_first = true },
			lua = { "stylua" },
			nix = { "alejandra" },
			json = { "prettierd" },
		},
	},
}
