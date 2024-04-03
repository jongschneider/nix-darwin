return {
	"luukvbaal/nnn.nvim",
	config = function()
		local nnn = require("nnn")
		nnn.setup({
			-- explorer = {
			--   cmd = "nnn",       -- command override (-F1 flag is implied, -a flag is invalid!)
			--   width = 24,        -- width of the vertical split
			--   side = "topleft",  -- or "botright", location of the explorer window
			--   session = "",      -- or "global" / "local" / "shared"
			--   tabs = true,       -- separate nnn instance per tab
			--   fullscreen = true, -- whether to fullscreen explorer window when current tab is empty
			-- },
			picker = {
				cmd = "nnn -a -Pp", -- command override (-p flag is implied)
				-- cmd = [[NNN_PLUG="p:preview-tui" ICONLOOKUP=1 tmux new-session nnn -a -Pp]],
				style = { border = "shadow" },
				style = {
					width = 0.9, -- percentage relative to terminal size when < 1, absolute otherwise
					height = 0.8, -- ^
					xoffset = 0.5, -- ^
					yoffset = 0.5, -- ^
					border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
				},
				session = "shared", -- or "global" / "local" / "shared"
				tabs = true, -- separate nnn instance per tab
				fullscreen = true, -- whether to fullscreen picker window when current tab is empty
			},
			auto_open = {
				setup = nil, -- or "explorer"q / "picker", auto open on setup function
				tabpage = nil, -- or "explorer" / "picker", auto open when opening new tabpage
				empty = false, -- only auto open on empty buffer
				ft_ignore = { -- dont auto open for these filetypes
					"gitcommit",
				},
			},
			auto_close = false, -- close tabpage/nvim when nnn is last window
			-- replace_netrw = "picker", -- or "explorer" / "picker"
			mappings = {
				{ "<C-t>", nnn.builtin.open_in_tab }, -- open file(s) in tab
				{ "<C-s>", nnn.builtin.open_in_split }, -- open file(s) in split
				{ "<C-v>", nnn.builtin.open_in_vsplit }, -- open file(s) in vertical split
				{ "<C-p>", nnn.builtin.open_in_preview }, -- open file in preview split keeping nnn focused
				{ "<C-y>", nnn.builtin.copy_to_clipboard }, -- copy file(s) to clipboard
				{ "<C-w>", nnn.builtin.cd_to_path }, -- cd to file directory
				{ "<C-e>", nnn.builtin.populate_cmdline }, -- populate cmdline (:) with file(s)
			},
			windownav = { -- window movement mappings to navigate out of nnn
				left = "<C-w>h",
				right = "<C-w>l",
				next = "<C-w>w",
				prev = "<C-w>W",
			},
			buflisted = false, -- whether or not nnn buffers show up in the bufferlist
			quitcd = nil, -- or "cd" / tcd" / "lcd", command to run on quitcd file if found
			offset = false, -- whether or not to write position offset to tmpfile(for use in preview-tui)
		})
	end,
}
