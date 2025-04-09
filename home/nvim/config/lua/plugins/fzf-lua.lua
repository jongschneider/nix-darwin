return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	opts = {},
	config = function()
		-- Register fzf-lua as the UI selector
		-- require("fzf-lua").register_ui_select()
		-- Integrate with Trouble.nvim
		local config = require("fzf-lua.config")
		-- local actions = require("trouble.sources.fzf").actions
		-- config.defaults.actions.files["ctrl-t"] = actions.open

		require("fzf-lua").setup({
			-- MISC GLOBAL SETUP OPTIONS, SEE BELOW
			-- fzf_bin = ...,
			-- each of these options can also be passed as function that return options table
			-- e.g. winopts = function() return { ... } end
			winopts = {
				-- Your other winopts settings can remain...
				on_create = function()
					-- Map <C-j> and <C-k> to proper fzf navigation within the popup
					vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
					vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
				end,
			},
			-- keymap = { ...  },      -- Neovim keymaps / fzf binds
			-- keymap = {
			-- 	fzf = {
			-- 		-- Add selected files to quickfix list with Ctrl-q
			-- 		["ctrl-q"] = "actions.file_qf_multi",
			-- 	},
			-- },
			-- actions = { ...  },     -- Fzf "accept" binds
			-- fzf_opts = { ...  },    -- Fzf CLI flags
			-- fzf_colors = { ...  },  -- Fzf `--color` specification
			-- hls = { ...  },         -- Highlights
			-- previewers = { ...  },  -- Previewers options
			-- SPECIFIC COMMAND/PICKER OPTIONS, SEE BELOW
			-- files = { ... },
		})
	end,
	keys = {
		-- {
		-- 	"<leader>ff",
		-- 	function()
		-- 		require("fzf-lua").files()
		-- 	end,
		-- 	desc = "Find Files in project directory",
		-- },
		-- {
		-- 	"<leader>fg",
		-- 	function()
		-- 		require("fzf-lua").live_grep()
		-- 	end,
		-- 	desc = "Find by grepping in project directory",
		-- },
		-- {
		-- 	"<leader>fc",
		-- 	function()
		-- 		require("fzf-lua").commands()
		-- 	end,
		-- 	desc = "[F]ind [C]ommands",
		-- },
		-- {
		-- 	"<leader>fh",
		-- 	function()
		-- 		require("fzf-lua").helptags()
		-- 	end,
		-- 	desc = "[F]ind [H]elp",
		-- },
		-- {
		-- 	"<leader>fk",
		-- 	function()
		-- 		require("fzf-lua").keymaps()
		-- 	end,
		-- 	desc = "[F]ind [K]eymaps",
		-- },
		-- {
		-- 	"<leader>fbi",
		-- 	function()
		-- 		require("fzf-lua").builtin()
		-- 	end,
		-- 	desc = "[F]ind [B]uilt[i]n FZF",
		-- },
		{
			"<leader>fbp",
			function()
				require("fzf-lua").dap_breakpoints()
			end,
			desc = "[F]ind [B]reak[p]oints FZF",
		},
		-- {
		-- 	"<leader>fw",
		-- 	function()
		-- 		require("fzf-lua").grep_cword()
		-- 	end,
		-- 	desc = "[F]ind current [W]ord",
		-- },
		-- {
		-- 	"<leader>fW",
		-- 	function()
		-- 		require("fzf-lua").grep_cWORD()
		-- 	end,
		-- 	desc = "[F]ind current [W]ORD",
		-- },
		-- {
		-- 	"<leader>fd",
		-- 	function()
		-- 		require("fzf-lua").diagnostics_document()
		-- 	end,
		-- 	desc = "[F]ind [D]iagnostics",
		-- },
		-- {
		-- 	"<leader>fr",
		-- 	function()
		-- 		require("fzf-lua").resume()
		-- 	end,
		-- 	desc = "[F]ind [R]esume",
		-- },
		-- {
		-- 	"<leader>fo",
		-- 	function()
		-- 		require("fzf-lua").oldfiles()
		-- 	end,
		-- 	desc = "[F]ind [O]ld Files",
		-- },
		-- {
		-- 	"<leader>,",
		-- 	function()
		-- 		require("fzf-lua").buffers()
		-- 	end,
		-- 	desc = "[,] Find existing buffers",
		-- },
		{
			"<leader>/",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "[/] Live grep the current buffer",
		},
	},
}
