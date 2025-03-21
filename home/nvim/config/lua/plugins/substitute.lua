return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")
		substitute.setup()

		local keymap = vim.keymap
		keymap.set("n", "P", substitute.operator, { desc = "Subtitute with motion" })
		keymap.set("n", "PP", substitute.line, { desc = "Subtitule line" })
		keymap.set("n", "Pl", substitute.eol, { desc = "Subtitute to endline" })
		keymap.set("x", "P", substitute.visual, { desc = "Subtitute in visual mode" })
	end,
}
