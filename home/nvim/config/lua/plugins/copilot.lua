return {
	"zbirenbaum/copilot.lua",
	opts = {
		copilot_model = "claude-3.7-sonnet",
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,
			keymap = {
				accept = "<C-l>",
				accept_word = "<C-j>",
				accept_line = "<C-k>",
				next = "<C-n>",
				prev = "<C-p>",
				dismiss = "<M-h>",
			},
		},
		-- suggestion = {
		-- 	enabled = false,
		-- },
		panel = {
			enabled = false,
		},
	},
}
