return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- optional = true,
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
		ft = { "markdown", "copilot-chat", "codecompanion" },
	},
	--------------------------------------------------------------------------------
	-- Markdown Previewer
	--------------------------------------------------------------------------------
	{
		"selimacerbas/markdown-preview.nvim",
		dependencies = { "selimacerbas/live-server.nvim" },
		ft = "markdown",
		cmd = {
			"MarkdownPreview",
			"MarkdownPreviewRefresh",
			"MarkdownPreviewStop",
		},
		config = function()
			require("markdown_preview").setup()
		end,
	},
}
