return {
	"folke/trouble.nvim",
	branch = "dev", -- IMPORTANT!
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble document_diagnostics<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble document_diagnostics filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp_definitions focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble quickfix<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
	opts = {
		auto_preview = true,
	}, -- for default options, refer to the configuration section for custom setup.
}
