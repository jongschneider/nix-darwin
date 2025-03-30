return {
	{
		"vim-test/vim-test",
		dependencies = {
			"preservim/vimux",
		},
		config = function()
			-- Check if we're in a tmux session
			local in_tmux = (os.getenv("TMUX") ~= nil)

			-- Set the appropriate test strategy
			if in_tmux then
				vim.cmd("let test#strategy = 'vimux'")
			else
				-- Use a different strategy when not in tmux, such as 'neovim'
				vim.cmd("let test#strategy = 'neovim'")
			end

			vim.keymap.set("n", "<leader>gt", ":TestNearest -coverprofile " .. vim.fn.getcwd() .. "/cover.cov -v<CR>")
			vim.keymap.set("n", "<leader>gf", ":TestFile -coverprofile " .. vim.fn.getcwd() .. "/cover.cov -v<CR>")
			vim.keymap.set("n", "<leader>ga", ":TestSuite -coverprofile " .. vim.fn.getcwd() .. "/cover.cov -v<CR>")
		end,
	},
	{
		"preservim/vimux",
	},
}
