local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"j-hui/fidget.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"banjo/contextfiles.nvim",
		{
			"Davidyz/VectorCode",
			version = "*",
			build = "pipx upgrade vectorcode",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
	opts = {
		adapters = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-3.7-sonnet",
						},
					},
				})
			end,
			-- ollama = function()
			-- 	return require("codecompanion.adapters").extend("ollama", {
			-- 		schema = {
			-- 			model = {
			-- 				default = "llama3.1:latest",
			-- 			},
			-- 			num_ctx = {
			-- 				default = 20000,
			-- 			},
			-- 		},
			-- 	})
			-- end,
		},
		prompt_library = {
			["context"] = {
				strategy = "chat",
				description = "Chat with context files",
				opts = {
					-- ...
				},
				prompts = {
					{
						role = "user",
						opts = {
							contains_code = true,
						},
						content = function(context)
							local ctx = require("contextfiles.extensions.codecompanion")

							local ctx_opts = {
								-- ...
							}
							local format_opts = {
								-- ...
							}

							return ctx.get(context.filename, ctx_opts, format_opts)
						end,
					},
				},
			},
			-- 			["Docusaurus"] = {
			-- 				strategy = "chat",
			-- 				description = "Write documentation for me",
			-- 				opts = {
			-- 					index = 11,
			-- 					is_slash_cmd = false,
			-- 					auto_submit = false,
			-- 					short_name = "docs",
			-- 				},
			-- 				references = {
			-- 					{
			-- 						type = "file",
			-- 						path = {
			-- 							"doc/.vitepress/config.mjs",
			-- 							"lua/codecompanion/config.lua",
			-- 							"README.md",
			-- 						},
			-- 					},
			-- 				},
			-- 				prompts = {
			-- 					{
			-- 						role = "user",
			-- 						content = [[I'm rewriting the documentation for my plugin CodeCompanion.nvim, as I'm moving to a vitepress website. Can you help me rewrite it?
			--
			-- I'm sharing my vitepress config file so you have the context of how the documentation website is structured in the `sidebar` section of that file.
			--
			-- I'm also sharing my `config.lua` file which I'm mapping to the `configuration` section of the sidebar.
			-- ]],
			-- 					},
			-- 				},
			-- 			},
			-- ["Test workflow"] = {
			-- 	strategy = "workflow",
			-- 	description = "Use a workflow to test the plugin",
			-- 	opts = {
			-- 		index = 4,
			-- 	},
			-- 	prompts = {
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Generate a Python class for managing a book library with methods for adding, removing, and searching books",
			-- 				opts = {
			-- 					auto_submit = false,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Write unit tests for the library class you just created",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Create a TypeScript interface for a complex e-commerce shopping cart system",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Write a recursive algorithm to balance a binary search tree in Java",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Generate a comprehensive regex pattern to validate email addresses with explanations",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Create a Rust struct and implementation for a thread-safe message queue",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Write a GitHub Actions workflow file for CI/CD with multiple stages",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Create SQL queries for a complex database schema with joins across 4 tables",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Write a Lua configuration for Neovim with custom keybindings and plugins",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		{
			-- 			{
			-- 				role = "user",
			-- 				content = "Generate documentation in JSDoc format for a complex JavaScript API client",
			-- 				opts = {
			-- 					auto_submit = true,
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- },
		},
		strategies = {
			chat = {
				adapter = "copilot",
				roles = {
					user = "jonathan-schneider-tl",
				},
				keymaps = {
					send = {
						modes = {
							i = { "<C-CR>", "<C-s>" },
						},
					},
					completion = {
						modes = {
							i = "<C-x>",
						},
					},
				},
				slash_commands = {
					["buffer"] = {
						opts = {
							keymaps = {
								modes = {
									i = "<C-b>",
								},
							},
						},
					},
					["help"] = {
						opts = {
							max_lines = 1000,
						},
					},
				},
				tools = {
					vectorcode = {
						description = "Run VectorCode to retrieve the project context.",
						callback = function()
							return require("vectorcode.integrations").codecompanion.chat.make_tool()
						end,
					},
				},
			},
			inline = {
				adapter = "copilot",
				keymaps = {
					accept_change = {
						modes = { n = "ga" },
						description = "Accept the suggested change",
					},
					reject_change = {
						modes = { n = "gr" },
						description = "Reject the suggested change",
					},
				},
			},
		},
		display = {
			action_palette = {
				provider = "default",
			},
			chat = {
				-- show_references = true,
				-- show_header_separator = false,
				-- show_settings = false,
			},
			diff = {
				-- enabled = true,
				provider = "mini_diff",
			},
		},
		opts = {
			log_level = "DEBUG",
		},
	},
	init = function()
		vim.cmd([[cab cc CodeCompanion]])

		nnoremap("<C-a>", "<cmd>CodeCompanionActions<CR>", { desc = "Open the action palette" })
		vnoremap("<C-a>", "<cmd>CodeCompanionActions<CR>", { desc = "Open the action palette" })

		nnoremap("<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle a chat buffer" })
		vnoremap("<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle a chat buffer" })
		vnoremap("<C-p>", "<cmd>'<,'>CodeCompanion<CR>", { desc = "Open selection in CodeCompanion [p]rompt" })

		nnoremap("ga", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add selected text to a chat buffer" })
		vnoremap("ga", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add selected text to a chat buffer" })
		require("plugins.custom.spinner"):init()
	end,
}
