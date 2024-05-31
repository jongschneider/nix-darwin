local wezterm = require("wezterm")
local color_scheme = "Catppuccin Frappe"
local env_scheme = "dark"
local assets = wezterm.config_dir .. "/assets"

local config = {
	color_scheme = color_scheme,
	set_environment_variables = {
		THEME = env_scheme,
	},
	macos_window_background_blur = 30,
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	native_macos_fullscreen_mode = true,
	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	},

	hide_tab_bar_if_only_one_tab = true,
	-- font = wezterm.font("MesloLGS Nerd Font Mono", { weight = "Regular" }),
	-- font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Regular" }),
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
	-- font = wezterm.font("Monaspace Krypton", { weight = "Regular" }),
	-- font = wezterm.font("MonaspiceKr Nerd Font Mono", { weight = "Regular" }),
	-- font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" }),
	harfbuzz_features = { "calt", "dlig", "clig=1", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
	font_size = 13,
	line_height = 1.3,
	adjust_window_size_when_changing_font_size = false,

	-- keys config
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
}

config.scrollback_lines = 3500

config.background = {
	{
		source = {
			Gradient = {
				colors = { "#303446" }, -- Base color for Frappé flavour on https://github.com/catppuccin/catppuccin
			},
		},
		width = "100%",
		height = "100%",
		opacity = 0.90,
	},
	-- This is the deepest/back-most layer. It will be rendered first
	{
		source = {
			File = {
				-- path = "/Users/jschneider/.config/wezterm/assets/blob_blue.gif",
				path = assets .. "/blob_blue.gif",
				speed = 0.001,
			},
		},
		height = "Cover",
		width = "100%",
		horizontal_align = "Center",
		vertical_align = "Middle",
		repeat_x = "NoRepeat",
		repeat_y = "NoRepeat",
		-- opacity = 1,
		opacity = 0.10,
		hsb = {
			hue = 0.9,
			saturation = 0.8,
			brightness = 0.1,
		},
	},
}

return config
