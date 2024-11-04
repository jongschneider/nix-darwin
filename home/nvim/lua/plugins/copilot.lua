return {
	{
		"zbirenbaum/copilot.lua",
		event = { "BufEnter" },
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
				},
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		event = { "BufEnter" },
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		event = "VeryLazy",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			-- { "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		keys = {
			{
				"<leader>cc",
				"<CMD>CopilotChatToggle<CR>",
			},
			{
				"<leader>cf",
				"<CMD>CopilotChatFixDiagnostic<CR>",
			},
			{
				"<leader>cm",
				"<CMD>CopilotChatCommitStaged<CR>",
			},
			{
				"<leader>cd",
				"<CMD>CopilotChatDocs<CR>",
			},
			{
				"<leader>ce",
				"<CMD>CopilotChatExplain<CR>",
			},
			{
				"<leader>cr",
				"<CMD>CopilotChatReset<CR>",
			},
			{
				"<leader>co",
				"<CMD>CopilotChatOptimize<CR>",
			},
			{
				"<leader>cp",
				function()
					local copilotchat = require("CopilotChat")
					local copilotchat_select = require("CopilotChat.select")

					local input = vim.fn.input("Prompt: ")
					if input ~= "" then
						copilotchat.ask(input, { selection = copilotchat_select.visual })
					end
				end,
			},
			{
				"<leader>cs",
				"<CMD>CopilotChatSelect<CR>",
			},
			{
				"<leader>ct",
				"<CMD>CopilotChatTests<CR>",
			},
		},
		opts = {
			-- debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
