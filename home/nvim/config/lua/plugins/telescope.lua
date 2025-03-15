-- https://www.youtube.com/watch?v=xdXE1tOT-qg&t=24s
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

-- example: TODO  **/*micro*/**
local live_multigrep = function(opts)
	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "%s%s+")
			local args = { "rg" }

			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			-- Handle multiple glob patterns after the search term
			for i = 2, #pieces do
				table.insert(args, "-g")
				table.insert(args, pieces[i])
			end

			-- Add the default ripgrep options
			local rg_opts =
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }

			-- Use vim.list_extend instead of tbl_flatten
			return vim.list_extend(args, rg_opts)
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})
	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Multi Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				cond = vim.fn.executable("cmake") == 1,
			},
		},
		config = function()
			local actions = require("telescope.actions")
			local trouble = require("trouble.sources.telescope")

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.delete_buffer,
							["<c-t>"] = trouble.open,
						},
						n = { ["<c-t>"] = trouble.open },
					},
					file_ignore_patterns = {
						"node_modules",
						"yarn.lock",
						".git",
						".sl",
						"_build",
						".next",
					},
					hidden = true,
					layout_strategy = "flex",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						vertical = { mirror = false },
						width = 0.87,
						height = 0.8,
						preview_cutoff = 120,
					},
				},
			})
			vim.keymap.set("n", "<leader>fg", live_multigrep, { desc = "[F]ind by [G]rep" })
			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
}
