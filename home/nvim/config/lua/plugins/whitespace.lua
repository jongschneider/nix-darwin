return {
	"ntpeters/vim-better-whitespace",
	config = function()
		-- Setup autocmd to check for and disable on ministarter
		vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
			pattern = "*",
			callback = function()
				-- Check for ministarter specifically
				if vim.bo.filetype == "ministarter" then
					-- Disable plugin for this buffer
					vim.b.better_whitespace_enabled = 0
					-- Disable highlighting
					vim.cmd("DisableWhitespace")
				end
			end,
		})
	end,
}
