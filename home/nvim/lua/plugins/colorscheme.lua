-- https://github.com/folke/tokyonight.nvim#%EF%B8%8F-configuration
return {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
    --   local bg = "#011628"
    --   local bg_dark = "#011423"
    --   local bg_highlight = "#143652"
    --   local bg_search = "#0A64AC"
    --   local bg_visual = "#275378"
    --   local fg = "#CBE0F0"
    --   local fg_dark = "#B4D0E9"
    --   local fg_gutter = "#627E97"
    --   local border = "#547998"
  
      require("tokyonight").setup({
        transparent = true,
        style = "moon",
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent", -- style for floating windows
        },
    --     on_colors = function(colors)
    --       colors.bg = bg
    --       colors.bg_dark = bg_dark
    --       colors.bg_float = bg_dark
    --       colors.bg_highlight = bg_highlight
    --       colors.bg_popup = bg_dark
    --       colors.bg_search = bg_search
    --       colors.bg_sidebar = bg_dark
    --       colors.bg_statusline = bg_dark
    --       colors.bg_visual = bg_visual
    --       colors.border = border
    --       colors.fg = fg
    --       colors.fg_dark = fg_dark
    --       colors.fg_float = fg
    --       colors.fg_gutter = fg_gutter
    --       colors.fg_sidebar = fg_dark
    --     end
      })
  
      vim.cmd("colorscheme tokyonight")
    end
  }
