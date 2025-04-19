return {
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = { "italic" },
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
				integrations = {
					blink_cmp = true,
					cmp = true,
					dap_ui = true,
					fidget = true,
					fzf = true,
					leap = true,
					gitsigns = true,
					harpoon = true,
					illuminate = true,
					indent_blankline = {
						enabled = false,
						scope_color = "sapphire",
						colored_indent_levels = false,
					},
					lsp_trouble = true,
					mini = {
						enabled = true,
						-- indentscope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
						-- indentscope_color = "pink", -- catppuccin color (eg. `lavender`) Default: text
						-- indentscope_color = "peach", -- catppuccin color (eg. `lavender`) Default: text
						indentscope_color = "mauve", -- catppuccin color (eg. `lavender`) Default: text
					},
					mason = true,
					notify = true,
					noice = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
					snacks = {
						enabled = true,
						indent_scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
					},
					symbols_outline = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					ufo = true,
					which_key = true,
				},

				compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
			})

			-- vim.cmd.colorscheme("catppuccin-frappe")
			--
			-- -- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
			-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			-- 	vim.api.nvim_set_hl(0, group, {})
			-- end

			local palette = require("catppuccin.palettes").get_palette("macchiato")

			vim.cmd.colorscheme("catppuccin-macchiato")

			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = palette.base })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = palette.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = palette.base })
			vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = palette.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = palette.base })
			vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = palette.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { fg = palette.blue, bg = palette.base })
			vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = palette.overlay2 })

			-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
			for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
				vim.api.nvim_set_hl(0, group, {})
			end
		end,
	},
}
