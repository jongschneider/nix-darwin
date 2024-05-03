-- configure wezterm to use the ~/.config/dotfiles directory for shared lua modules
-- local dotfiles = os.getenv("HOME") .. "/.config/dotfiles"
-- package.path = package.path .. ";" .. dotfiles .. "/?.lua;" .. dotfiles .. "/?/?.lua;" .. dotfiles .. "/?/init.lua"

-- local h = require("utils.helpers")
-- local b = require("utils.background")
local wezterm = require("wezterm")
-- local custom_config = require("base.config")

-- local theme = custom_config.theme or b.get_default_theme()
-- local assets = wezterm.config_dir .. "/assets"

local color_scheme = "Catppuccin Frappe"
local env_scheme = "dark"

local config = {
    color_scheme = color_scheme,
    set_environment_variables = {
        THEME = env_scheme,
    },
    -- background = {
    --     source = { 
    --         File = "./assets/blob_blue.gif",
    --      },
    --     height = "Cover",
    --     width = "Cover",
    --     horizontal_align = "Center",
    --     repeat_x = "NoRepeat",
    --     repeat_y = "NoRepeat",
    --     opacity = 1,
    -- },
  macos_window_background_blur = 30,
--   enable_tab_bar = false,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  native_macos_fullscreen_mode = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  -- font config
  font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" }),
--   font_rules = {
--     {
--       italic = true,
--       font = wezterm.font(custom_config.italic_font, { weight = "Medium" }),
--     },
--   },
  harfbuzz_features = { "calt", "dlig", "clig=1", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
  font_size = 13,
  line_height = 1.1,
  adjust_window_size_when_changing_font_size = false,

  -- keys config
  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = false,
}

config.background = {
    {
        source = {
          Gradient = {
            -- colors = { h.is_dark and "#000000" or "#ffffff" },
            -- colors = { "#000000"},
            colors = { "#1E1E2E"},
          },
        },
        width = "100%",
        height = "100%",
        opacity = 0.85,
      },
    -- This is the deepest/back-most layer. It will be rendered first
    {
      source = {
        File = {
            path = "/Users/jschneider/.config/wezterm/assets/blob_blue.gif",
            speed = 0.001,
        },
      },
        height = "Cover",
        -- width = "Cover",
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
    --   -- The texture tiles vertically but not horizontally.
    --   -- When we repeat it, mirror it so that it appears "more seamless".
    --   -- An alternative to this is to set `width = "100%"` and have
    --   -- it stretch across the display
    --   repeat_x = 'Mirror',
    --   hsb = dimmer,
    --   -- When the viewport scrolls, move this layer 10% of the number of
    --   -- pixels moved by the main viewport. This makes it appear to be
    --   -- further behind the text.
    --   attachment = { Parallax = 0.1 },
    },
}
-- if h.is_dark then
--   config.color_scheme = theme
--   config.set_environment_variables = {
--     THEME_FLAVOUR = "mocha",
--   }
--   config.background = {
--     -- custom_config.wallpaper_dir and b.get_random_wallpaper(custom_config.wallpaper_dir .. "/*.{png,jpg,jpeg}") or {},
--     -- b.get_random_animation(assets .. "/*.gif"),
--     b.get_background(),
--   }

--   if custom_config["wallpaper_dir"] ~= nil then
--     table.insert(config.background, 1, b.get_random_wallpaper(custom_config.wallpaper_dir .. "/*.{png,jpg,jpeg}"))
--   end
-- else
--   config.color_scheme = "Catppuccin Latte"
--   config.window_background_opacity = 1
--   config.set_environment_variables = {
--     THEME_FLAVOUR = "latte",
--   }
--   config.background = {
--     b.get_background(),
--   }
-- end

return config