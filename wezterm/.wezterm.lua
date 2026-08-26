-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
--
config.prefer_to_spawn_tabs = true
-- Enable OSC 52 clipboard integration for SSH/tmux
-- This allows remote applications (tmux, nvim) to copy to local clipboard
config.enable_csi_u_key_encoding = true

-- Ensure OSC 52 clipboard integration is enabled
-- Wezterm supports OSC 52 by default, but we explicitly configure it here
config.term = "xterm-256color"

-- For example, changing the color scheme:
config.color_scheme = "AdventureTime"
config.font = wezterm.font("JetBrains Mono")
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- Keys setup
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 4000 }

config.keys = {
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if not sel or sel == "" then
				window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
			else
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
			end
		end),
	},

	{ key = "_", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },
	{ key = "_", mods = "CTRL", action = act.DisableDefaultAssignment },

	{ key = "v", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
	-- { key = 'p', mods = 'CTRL', action = act.SendKey{ key='UpArrow' }},
	-- { key = 'n', mods = 'CTRL', action = act.SendKey{ key='DownArrow' }},

	-- Trying to make Copy & Search mode more useful
	-- Here are some ideas https://github.com/wezterm/wezterm/issues/1988
	-- {
	-- 	key = "x",
	-- 	mods = "CTRL|SHIFT",
	-- 	action = act.Multiple({
	-- 		-- act.Search({ CaseInSensitiveString = "" }),
	-- 		act.CopyMode("ClearPattern"),
	-- 		act.ActivateCopyMode,
	-- 	}),
	-- },
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(act.Search({ CaseInSensitiveString = "" }), pane)
			window:perform_action(act.Search("CurrentSelectionOrEmptyString"), pane)
			window:perform_action(
				act.Multiple({
					act.CopyMode("ClearPattern"),
					act.CopyMode("ClearSelectionMode"),
					act.CopyMode("MoveToScrollbackBottom"),
				}),
				pane
			)
		end),
	},

	-- Window management
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical,
	},
	{
		key = ";",
		mods = "LEADER",
		action = act.SplitHorizontal,
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
}

config.default_prog = { "pwsh.exe", "-NoLogo" }
config.enable_scroll_bar = true
-- config.min_scroll_bar_height = "50px"

-- and finally, return the configuration to wezterm
return config
