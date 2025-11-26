-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Enable auto-reload of the configuration file
config.automatically_reload_config = true

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 18

-- Tabs
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false


config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- Set padding for the window
config.window_padding = {
    left = 50,    -- Adjust as needed
    right = 30,   -- Adjust as needed
    top = 40,     -- Adjust as needed
    bottom = 40,   -- Adjust as needed
}

-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
	tab_bar = {
        -- Set the background to be fully transparent
        background = "rgba(0, 0, 0, 0)",

        -- Active tab styling
        active_tab = {
            bg_color = "#44FFB1",      -- Background color for active tab
            fg_color = "#011423",      -- Foreground (text) color for active tab
            intensity = "Bold",        -- Make the text bold
            underline = "Single",      -- Underline the active tab
        },

        -- Inactive tab styling
        inactive_tab = {
            bg_color = "rgba(33, 73, 105, 0.5)",  -- Semi-transparent background for inactive tabs
            fg_color = "#CBE0F0",                -- Foreground (text) color for inactive tabs
        },

        -- Inactive tab when hovered
        inactive_tab_hover = {
            bg_color = "rgba(15, 197, 237, 0.7)", -- Semi-transparent background when hovering over inactive tab
            fg_color = "#011423",                -- Foreground (text) color when hovering
        },
    },
}

-- and finally, return the configuration to wezterm
config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},

  -- Pane management
  -- Split panes (similar to iTerm2)
  {key="d", mods="CMD", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
  {key="d", mods="CMD|SHIFT", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},

  -- Close current pane
  {key="w", mods="CMD", action=wezterm.action.CloseCurrentPane{confirm=true}},

  -- Navigate between panes with CMD+Arrow keys
  {key="LeftArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Left")},
  {key="RightArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Right")},
  {key="UpArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Up")},
  {key="DownArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Down")},

  -- macOS-style word and line navigation with Option+Arrow
  {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},  -- Move backward one word
  {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}}, -- Move forward one word

  -- CMD+Arrow for beginning/end of line (macOS style)
  {key="LeftArrow", mods="CMD|SHIFT", action=wezterm.action{SendString="\x1bOH"}}, -- Start of line
  {key="RightArrow", mods="CMD|SHIFT", action=wezterm.action{SendString="\x1bOF"}}, -- End of line
}

return config
