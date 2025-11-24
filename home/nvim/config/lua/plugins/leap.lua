return {
	"ggandor/leap.nvim",
	config = function()
		-- Default mappings are now set automatically by leap.
		-- Configure or override here only if needed.
		require("leap").setup({})
		-- Example custom remaps (commented out):
		-- local leap = require("leap")
		-- vim.keymap.set({"n","x","o"}, "s", leap.leap, { desc = "Leap forward" })
	end,
}
