return {
	"mikavilpas/yazi.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			-- '<leader>-',
			"-",
			function()
				require("yazi").yazi()
			end,
			desc = "Open the file manager",
		},
		{
			-- Open in the current working directory
			-- '<leader>cw',
			"<leader>-",
			function()
				require("yazi").yazi(nil, vim.fn.getcwd())
			end,
			desc = "Open the file manager in nvim's working directory",
		},
	},
	-- keymaps = {
	-- 	show_help = "<f1>",
	-- 	open_file_in_vertical_split = "<c-v>",
	-- 	open_file_in_horizontal_split = "<c-x>",
	-- 	open_file_in_tab = "<c-t>",
	-- 	grep_in_directory = "<c-s>",
	-- 	replace_in_directory = "<c-g>",
	-- 	cycle_open_buffers = "<tab>",
	-- 	copy_relative_path_to_selected_files = "<c-y>",
	-- 	send_to_quickfix_list = "<c-q>",
	-- },
}
