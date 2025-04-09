return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")
		substitute.setup()

		local keymap = vim.keymap
		keymap.set("n", "<leader>p", substitute.operator, { desc = "Subtitute with motion" })
	end,
}
