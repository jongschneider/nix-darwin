return {
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					barbar = true,
					cmp = true,
					dap_ui = true,
					fidget = true,
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
						indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
					},
					mason = true,
					notify = true,
					noice = true,
					nvimtree = true,
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
					neotree = true,
					symbols_outline = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					ufo = true,
					which_key = true,
				},
			})

			vim.cmd.colorscheme("catppuccin-frappe")

			-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
			for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
				vim.api.nvim_set_hl(0, group, {})
			end
		end,
	},
}
