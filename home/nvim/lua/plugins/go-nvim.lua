return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup({
			go = "go",
			verbose = true,
			gocoverage_sign = "█",
			test_runner = "go",
			run_in_floaterm = true,
			icons = { breakpoint = "🔴", currentpos = "⚠️" },
			floaterm = { -- position
				posititon = "bottom", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
				width = 0.98, -- width of float window if not auto
				height = 0.60, -- height of float window if not auto
				title_colors = "dracula", -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
				-- can also set to a list of colors to define colors to choose from
				-- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
				border = "rounded",
			},
			trouble = true,
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
