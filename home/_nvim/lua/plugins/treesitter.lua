return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		event = { "BufEnter" },
		dependencies = {
			-- Additional text objects for treesitter
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			---@diagnostic disable: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"css",
					"gleam",
					"graphql",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"ocaml",
					"ocaml_interface",
					"prisma",
					"tsx",
					"typescript",
					"vim",
					-- "yaml", This is currently borked see: https://github.com/ikatyang/tree-sitter-yaml/issues/53
				},
				sync_install = false,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
					disable = { "ocaml", "ocaml_interface" },
				},
				autopairs = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				--[[ context_commentstring = {
					enable = true,
					enable_autocmd = false,
				}, ]]
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 3,
				trim_scope = "outer",
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
						"for", -- These won't appear in the context
						"while",
						"if",
						"switch",
						"case",
						"element",
						"call",
					},
				},
				exact_patterns = {},

				zindex = 20, -- The Z-index of the context window
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				separator = "-", -- Separator between context and content. Should be a single character string, like '-'.
			})
		end,
	},
}
