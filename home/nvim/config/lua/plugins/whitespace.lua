return {
	"ntpeters/vim-better-whitespace",
	event = "VeryLazy", -- Load this plugin after everything else
	config = function()
		-- Set global variable for dashboard filetypes blacklist
		vim.g.better_whitespace_filetypes_blacklist = {
			"ministarter",
			"snacks_dashboard", -- Add the dashboard filetypes here
		}
	end,
}
