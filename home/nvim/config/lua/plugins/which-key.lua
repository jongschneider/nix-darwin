return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Register debugging key group with correct format
		wk.add({
			{ "<leader>d", group = "Debug" },
			-- {
			-- 	"<leader>dA",
			-- 	function()
			-- 		require("dap-go").debug_test_file()
			-- 	end,
			-- 	desc = "Debug all tests in current file",
			-- },
			-- { "<leader>dB", desc = "Set conditional breakpoint" },
			-- { "<leader>dO", ":DapStepOut<CR>", desc = "Step out" },
			-- {
			-- 	"<leader>dT",
			-- 	function()
			-- 		require("dap-go").debug_last_test()
			-- 	end,
			-- 	desc = "Debug last Go test",
			-- },
			-- { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
			-- { "<leader>dc", ":DapContinue<CR>", desc = "Start/Continue debugging" },
			-- { "<leader>de", desc = "Evaluate expression" },
			-- { "<leader>df", desc = "Show frames" },
			-- { "<leader>di", ":DapStepInto<CR>", desc = "Step into" },
			-- { "<leader>dl", desc = "Set log point" },
			-- { "<leader>do", ":DapStepOver<CR>", desc = "Step over" },
			-- { "<leader>dp", ":lua require('dap').pause()<CR>", desc = "Pause execution" },
			-- { "<leader>dr", ":lua require('dap').restart()<CR>", desc = "Restart debugging" },
			-- { "<leader>ds", desc = "Show scopes" },
			-- {
			-- 	"<leader>dt",
			-- 	function()
			-- 		require("dap-go").debug_test()
			-- 	end,
			-- 	desc = "Debug Go test under cursor",
			-- },
			-- { "<leader>du", ":lua require('dapui').toggle()<CR>", desc = "Toggle DAP UI" },
			-- { "<leader>dx", ":DapTerminate<CR>", desc = "Terminate debugging" },
		})
	end,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
