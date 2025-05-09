-- Diagnostic signs
-- https://github.com/folke/trouble.nvim/issues/52
local signs = {
	Error = "",
	Warn = " ",
	Hint = "",
	Info = " ",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
return {
	"folke/trouble.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	-- branch = "dev", -- IMPORTANT!
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>fq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
	opts = {
		auto_preview = true,
	}, -- for default options, refer to the configuration section for custom setup.
}
