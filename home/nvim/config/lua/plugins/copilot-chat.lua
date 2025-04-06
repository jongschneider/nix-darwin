return {
	{
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			build = "make tiktoken",
			branch = "main",
			dependencies = {
				-- { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
				{ "zbirenbaum/copilot.lua" },
				{ "nvim-lua/plenary.nvim" },
			},
			opts = {
				-- model = "o1-mini", -- GPT model to use, 'gpt-3.5-turbo', 'gpt-4', or 'gpt-4o'
				chat_autocomplete = true,
				question_header = " ",
				answer_header = " ",
				error_header = "🚨",
				auto_follow_cursor = true, -- Don't follow the cursor after getting response
				auto_insert_mode = true,
				show_help = true, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
				mappings = {
					-- Use tab for completion
					complete = {
						detail = "Use @<Tab> or /<Tab> for options.",
						insert = "<Tab>",
					},
					-- Close the chat
					close = {
						normal = "q",
						insert = "<C-c>",
					},
					-- Reset the chat buffer
					reset = {
						normal = "<C-x>",
						insert = "<C-x>",
					},
					-- Submit the prompt to Copilot
					submit_prompt = {
						normal = "<CR>",
						insert = "<C-s>",
					},
					-- Accept the diff
					accept_diff = {
						normal = "<C-y>",
						insert = "<C-y>",
					},
					-- Yank the diff in the response to register
					yank_diff = {
						normal = "gmy",
					},
					-- Show the diff
					show_diff = {
						normal = "gmd",
					},
					-- Show the prompt
					show_info = {
						normal = "gmp",
					},
					-- Show the user selection
					show_context = {
						normal = "gms",
					},
				},
			},
			config = function(_, opts)
				local chat = require("CopilotChat")
				local select = require("CopilotChat.select")
				-- Use unnamed register for the selection
				opts.selection = select.unnamed

				chat.setup(opts)

				vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
					chat.ask(args.args, { selection = select.visual })
				end, { nargs = "*", range = true })

				-- Inline chat with Copilot
				vim.api.nvim_create_user_command("CopilotChatInline", function(args)
					chat.ask(args.args, {
						selection = select.visual,
						window = {
							layout = "float",
							relative = "cursor",
							width = 1,
							height = 0.4,
							row = 1,
						},
					})
				end, { nargs = "*", range = true })

				-- Restore CopilotChatBuffer
				vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
					chat.ask(args.args, { selection = select.buffer })
				end, { nargs = "*", range = true })

				-- -- Custom buffer for CopilotChat
				-- vim.api.nvim_create_autocmd("BufEnter", {
				-- 	pattern = "copilot-*",
				-- 	callback = function()
				-- 		-- Get current filetype and set it to markdown if the current filetype is copilot-chat
				-- 		local ft = vim.bo.filetype
				-- 		if ft == "copilot-chat" then
				-- 			vim.bo.filetype = "markdown"
				-- 		end
				-- 	end,
				-- })

				-- Add which-key mappings
				local wk = require("which-key")
				wk.add({
					{ "<leader>gm", group = "+Copilot Chat" }, -- group
					{ "<leader>gmd", desc = "Show diff" },
					{ "<leader>gmp", desc = "System prompt" },
					{ "<leader>gms", desc = "Show selection" },
					{ "<leader>gmy", desc = "Yank diff" },
				})
			end,
			event = "VeryLazy",
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
		},
	},
}
