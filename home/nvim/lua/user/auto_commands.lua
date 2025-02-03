--[[
 █████╗ ██╗   ██╗████████╗ ██████╗  ██████╗███╗   ███╗██████╗ ███████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝
███████║██║   ██║   ██║   ██║   ██║██║     ██╔████╔██║██║  ██║███████╗
██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║╚██╔╝██║██║  ██║╚════██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗██║ ╚═╝ ██║██████╔╝███████║
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝╚═╝     ╚═╝╚═════╝ ╚══════╝
See `:help lua-guide-autocommands`
--]]

-- Help windows will always open vertically on the right side of your screen
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

-- Auto-resize windows on terminal buffer resize
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("WinResize", { clear = true }),
	pattern = "*",
	command = "wincmd =",
	desc = "Auto-resize windows on terminal buffer resize.",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Enable word wrap and spell check for text-focused files (git commits, markdown, plain text)
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("edit_text", { clear = true }),
	pattern = { "gitcommit", "markdown", "txt" },
	desc = "Enable spell checking and text wrapping for certain filetypes",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Markdown files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
	pattern = { "*.mdx", "*.md" },
	callback = function()
		vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
	end,
})

-- Conf files as shell scripts
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = { "*.conf" },
	callback = function()
		vim.cmd([[set filetype=sh]])
	end,
})

-- Ghostty config as TOML
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = { "config" },
	callback = function()
		vim.cmd([[set filetype=toml]])
		vim.cmd([[LspStop]])
	end,
})
