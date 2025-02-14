return {
	{
		"vim-test/vim-test",
		dependencies = {
			"preservim/vimux",
		},
		-- set the vim-test strategy to open in a tmux pane
		-- vim.keymap.set("n", "<leader>gt", ":TestNearest<CR>"),
		vim.keymap.set("n", "<leader>gt", ":TestNearest -coverprofile " .. vim.fn.getcwd() .. "/cover.cov -v<CR>"),
		-- vim.keymap.set("n", "<leader>gf", ":TestFile<CR>"),
		vim.keymap.set("n", "<leader>gf", ":TestFile -coverprofile " .. vim.fn.getcwd() .. "/cover.cov -v<CR>"),
		-- vim.keymap.set("n", "<leader>ga", ":TestSuite<CR>"),
		vim.keymap.set("n", "<leader>ga", ":TestSuite -coverprofile " .. vim.fn.getcwd() .. "/cover.cov -v<CR>"),
		vim.cmd("let test#strategy = 'vimux'"),
	},
	{
		"preservim/vimux",
	},
}

