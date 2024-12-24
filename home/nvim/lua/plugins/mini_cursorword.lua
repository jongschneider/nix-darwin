return {
	{
        "echasnovski/mini.cursorword",
        event = "VeryLazy",
        config = function()
            require("mini.cursorword").setup({})
        end,
    },
	{
		"echasnovski/mini.move",
		version = false,
		opts = {
			-- TODO - these amppings simply do not work...
			mappings = {
				left = "<a-h>",
				right = "<a-l>",
				down = "<a-j>",
				up = "<a-k>",
				line_left = "<a-h>",
				line_right = "<a-l>",
				line_down = "<a-j>",
				line_up = "<a-k>",
			},
			options = {
				reindent_linewise = true,
			},
		},
		config = function(_, opts)
			require("mini.move").setup(opts)
		end,
	},
}