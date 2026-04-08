return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local ts_select = require("nvim-treesitter-textobjects.select")

		local keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
			["as"] = { query = "@local.scope", query_group = "locals" },
		}

		for key, query in pairs(keymaps) do
			local q = type(query) == "string" and query or query.query
			local qg = type(query) == "table" and query.query_group or nil
			vim.keymap.set({ "x", "o" }, key, function()
				ts_select.select_textobject(q, qg)
			end, { desc = "Textobject: " .. q })
		end
	end,
}
