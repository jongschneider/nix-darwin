return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "go" },
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-SPACE>", -- set to `false` to disable one of the mappings
					node_incremental = "<C-SPACE>",
					scope_incremental = false,
					node_decremental = "<Backspace>",
				},
			},
			modules = {},
		})
	end,
}
