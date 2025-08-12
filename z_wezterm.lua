-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

local home_dir = os.getenv("HOME")
-- wezterm.log_info("Home directory: " .. home_dir)

-- local image_path = home_dir .. "/dotfiles/images/wallpaper-1.jpeg"
local image_path = home_dir .. "/dotfiles/images/fawkes-wallpaper.jpg"
-- wezterm.log_info("Image path: " .. image_path)

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set the font
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 20.0

-- color scheme
config.color_scheme = "Catppuccin Mocha"

-- window opacity and blur
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20

-- tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true

config.window_frame = {
    font_size = 14.0,
    active_titlebar_bg = "#111111",
    inactive_titlebar_bg = "#000000",
}

config.window_background_image = image_path

config.window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = 0.5,

    -- You can adjust the hue by scaling its value.
    -- a multiplier of 1.0 leaves the value unchanged.
    hue = 1.0,

    -- You can adjust the saturation also.
    saturation = 1,
}

config.colors = {
    tab_bar = {
        -- The color of the inactive tab bar edge/divider
        inactive_tab_edge = "#575757",
        active_tab = {
            -- The color of the background area for the tab
            bg_color = "#089cec",
            -- The color of the text for the tab
            fg_color = "#ffffff",
        },
        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
            bg_color = "#1b1032",
            fg_color = "#808080",
        },
    },
}

-- config.window_close_confirmation = 'AlwaysPrompt'
config.window_close_confirmation = "NeverPrompt"

-- window padding
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 0,
}

-- scrollback lines
config.scrollback_lines = 10000

-- Keybindings
config.keys = {
    {
        key = "k",
        mods = "CMD",
        action = wezterm.action.Multiple({
            wezterm.action.ClearScrollback("ScrollbackAndViewport"), -- Clears history
            wezterm.action.SendKey({ key = "l", mods = "CTRL" }), -- Clears screen
        }),
    },
    { key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
}

wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    -- window:gui_window():maximize()
    window:gui_window():toggle_fullscreen()
end)

-- Add this line to prevent the extra shell level
config.default_prog = { "/bin/zsh" }

-- and finally, return the configuration to wezterm
return config
