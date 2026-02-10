-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Enable OSC 52 clipboard integration for SSH/tmux
-- This allows remote applications (tmux, nvim) to copy to local clipboard
config.enable_csi_u_key_encoding = true

-- Ensure OSC 52 clipboard integration is enabled
-- Wezterm supports OSC 52 by default, but we explicitly configure it here
config.term = "wezterm"

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.keys = {
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
        local sel = window:get_selection_text_for_pane(pane)
        if (not sel or sel == '') then
          window:perform_action(wezterm.action.SendKey{ key='c', mods='CTRL' }, pane)
        else
          window:perform_action(wezterm.action{ CopyTo = 'ClipboardAndPrimarySelection' }, pane)
        end
      end), 
    },
	{ key = 'v', mods = 'CTRL', action = wezterm.action.PasteFrom 'PrimarySelection' },
	{ key = 'p', mods = 'CTRL', action = wezterm.action.SendKey{ key='UpArrow' }},
	{ key = 'n', mods = 'CTRL', action = wezterm.action.SendKey{ key='DownArrow' }},
}

config.default_prog = { 'pwsh.exe', '-NoLogo' }
config.enable_scroll_bar = true

-- and finally, return the configuration to wezterm
return config