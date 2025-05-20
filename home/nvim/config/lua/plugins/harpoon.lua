return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		-- Or keep it and add keys to trigger loading
		keys = {
			"<leader>ho",
			"<leader>ha",
			"<leader>hr",
			"<leader>hc",
			"<leader>1",
			"<leader>2",
			"<leader>3",
			"<leader>4",
			"<leader>5",
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			-- Define navigation function factory
			local function nav(n)
				return function()
					harpoon:list():select(n)
				end
			end

			-- Map keybindings
			vim.keymap.set("n", "<leader>ho", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Open harpoon menu" })
			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "Add file to harpoon" })
			vim.keymap.set("n", "<leader>hr", function()
				harpoon:list():remove()
			end, { desc = "Remove file from harpoon" })
			vim.keymap.set("n", "<leader>hc", function()
				harpoon:list():clear()
			end, { desc = "Clear all harpooned files" })

			-- Navigation keymaps
			vim.keymap.set("n", "<leader>1", nav(1), { desc = "Navigate to harpooned file 1" })
			vim.keymap.set("n", "<leader>2", nav(2), { desc = "Navigate to harpooned file 2" })
			vim.keymap.set("n", "<leader>3", nav(3), { desc = "Navigate to harpooned file 3" })
			vim.keymap.set("n", "<leader>4", nav(4), { desc = "Navigate to harpooned file 4" })
			vim.keymap.set("n", "<leader>5", nav(5), { desc = "Navigate to harpooned file 5" })
		end,
	},
}
