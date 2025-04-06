return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- optional = true,
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
		ft = { "markdown", "copilot-chat" },
	},
	--------------------------------------------------------------------------------
	-- Markdown Previewer
	--------------------------------------------------------------------------------
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		cmd = {
			"MarkdownPreviewToggle",
			"MarkdownPreview",
			"MarkdownPreviewStop",
		},
	},
}
