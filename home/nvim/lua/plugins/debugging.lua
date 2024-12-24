return {
	"mfussenegger/nvim-dap",
	"leoluz/nvim-dap-go",
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		-- config = function()
		--     require("configs.dap_related.nvim_dap_ui")
		-- end,
		config = function()
			require("dapui").setup()
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
		},
		-- config = function()
		--     require("configs.dap_related.mason_dap")
		-- end,
		config = function()
			require("mason-nvim-dap").setup()
		end,
	},
}

