-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Workspace layouts
wezterm.on("gui-startup", function(cmd)
	if wezterm.hostname() ~= "mac.home" then return end
	-- Workspace 1: Storybook HENK
	local _, _, win1 = mux.spawn_window({
		workspace = "Storybook HENK",
		cwd = wezterm.home_dir .. "/Sites/storybook-henk",
	})
	local left1 = win1:active_tab():active_pane()
	local right1 = left1:split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir .. "/Sites/storybook-henk",
	})
	left1:send_text("crush\n")
	right1:send_text("nn .\n")

	left1:activate()

	local git1 = win1:spawn_tab({ cwd = wezterm.home_dir .. "/Sites/storybook-henk" })
	git1:active_pane():send_text("git status\n")
	git1:set_title("git")

	local dev1 = win1:spawn_tab({ cwd = wezterm.home_dir .. "/Sites/storybook-henk" })
	-- dev1:active_pane():send_text("npm run storybook\n")
	dev1:set_title("dev")
	local dev1_right = dev1:active_pane():split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir .. "/Sites/storybook-henk",
	})
	dev1_right:send_text("ntl\n")

	-- Workspace 2: HENK Shopify
	local _, _, win2 = mux.spawn_window({
		workspace = "HENK Shopify",
		cwd = wezterm.home_dir .. "/Sites/studio-henk",
	})
	local left2 = win2:active_tab():active_pane()
	local right2 = left2:split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir .. "/Sites/studio-henk",
	})
	left2:send_text("crush\n")
	right2:send_text("nn .\n")

	left2:activate()

	local git2 = win2:spawn_tab({ cwd = wezterm.home_dir .. "/Sites/studio-henk" })
	git2:active_pane():send_text("git status\n")
	git2:set_title("git")

	local dev2 = win2:spawn_tab({ cwd = wezterm.home_dir .. "/Sites/studio-henk" })
	-- dev2:active_pane():send_text("themedev_dev\n")
	dev2:set_title("dev")
	local dev2_right = dev2:active_pane():split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir .. "/Sites/studio-henk",
	})
	dev2_right:send_text("ntl\n")

	-- Workspace 3: WezTerm Conf
	local _, _, win3 = mux.spawn_window({
		workspace = "WezTerm Conf",
		cwd = wezterm.home_dir,
	})
	local left3 = win3:active_tab():active_pane()
	local right3 = left3:split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir,
	})
	left3:send_text("crush\n")
	right3:send_text("nn ~/.wezterm.lua\n")
	left3:activate()

	-- Workspace 4: default
	local _, _, win4 = mux.spawn_window({
		workspace = "default",
		cwd = wezterm.home_dir,
	})
	local tt_tab = win4:spawn_tab({ cwd = wezterm.home_dir })
	tt_tab:active_pane():send_text("tt\n")
	tt_tab:set_title("todos")

	-- Workspace 5: Dotfiles
	local _, _, win5 = mux.spawn_window({
		workspace = "Dotfiles",
		cwd = wezterm.home_dir .. "/dotfiles",
	})
	local left5 = win5:active_tab():active_pane()
	local right5 = left5:split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir .. "/dotfiles",
	})
	left5:send_text("crush\n")
	right5:send_text("nn .\n")
	left5:activate()

	local term5 = win5:spawn_tab({ cwd = wezterm.home_dir .. "/dotfiles" })
	term5:set_title("terminal")

	local git5 = win5:spawn_tab({ cwd = wezterm.home_dir .. "/dotfiles" })
	-- git5:active_pane():send_text("git status\n")
	git5:set_title("git")

	win4:gui_window():maximize()

	-- Workspace: henk-render (remote via SSH)
	local _, _, winR = mux.spawn_window({ workspace = "henk-render" })
	local leftR = winR:active_tab():active_pane()
	leftR:send_text("ssh mini -t 'zsh -i -l -c \"cd /Users/henk3d/HENK-3D/henk-render && crush\"'\n")
	local rightR = leftR:split({ direction = "Right", size = 0.5 })
	rightR:send_text("ssh mini -t 'zsh -i -l -c \"cd /Users/henk3d/HENK-3D/henk-render && nn .\"'\n")
	leftR:activate()

	local gitR = winR:spawn_tab({})
	gitR:active_pane():send_text("ssh mini -t 'zsh -i -l -c \"cd /Users/henk3d/HENK-3D/henk-render && git status; exec $SHELL\"'\n")
	gitR:set_title("git")

	local termR = winR:spawn_tab({})
	termR:active_pane():send_text("ssh mini -t 'zsh -i -l -c \"cd /Users/henk3d/HENK-3D/henk-render && exec $SHELL\"'\n")
	termR:set_title("terminal")

	mux.set_active_workspace("default")
end)

wezterm.on("gui-startup", function(cmd)
	if wezterm.hostname() ~= "HENK3Ds-Mac-mini.local" then return end

	-- Workspace: henk-render
	local _, _, win = mux.spawn_window({
		workspace = "henk-render",
		cwd = wezterm.home_dir .. "/HENK-3D/henk-render",
	})
	local left = win:active_tab():active_pane()
	local right = left:split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir .. "/HENK-3D/henk-render",
	})
	left:send_text("crush\n")
	right:send_text("nn .\n")

	local git_tab = win:spawn_tab({ cwd = wezterm.home_dir .. "/HENK-3D/henk-render" })
	git_tab:active_pane():send_text("git status\n")
	git_tab:set_title("git")

	local term_tab = win:spawn_tab({ cwd = wezterm.home_dir .. "/HENK-3D/henk-render" })
	term_tab:set_title("terminal")

	mux.set_active_workspace("henk-render")
end)

-- wezterm.on("window-config-reloaded", function(window, pane)
-- 	wezterm.log_info("window-config-reloaded fired")
-- 	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
-- end)

wezterm.on("update-status", function(window, pane)
	local workspace = window:active_workspace()
	local colors = {
		["default"] = "#7aa2f7",
		["Storybook HENK"] = "#9ece6a",
		["HENK Shopify"] = "#e0af68",
		["WezTerm Conf"] = "#bb9af7",
		["Dotfiles"] = "#2ac3de",
		["henk-render"] = "#f7768e",
	}
	local color = colors[workspace] or "#7aa2f7"
	local time = wezterm.strftime("%H:%M")

	local hostname = wezterm.hostname()
	local user = os.getenv("USER") or ""
	local proc = pane:get_foreground_process_name() or ""
	local is_ssh = proc:find("ssh") ~= nil

	local host_text = ""
	if is_ssh then
		local cmdline = table.concat(pane:get_foreground_process_info().argv or {}, " ")
		local remote = cmdline:match("%s(%S+)%s*$") or "remote"
		host_text = "  @" .. remote .. "  "
	else
		host_text = "  " .. user .. "@" .. hostname .. "  "
	end

	window:set_left_status("")
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#565f89" } },
		{ Text = "  " .. time .. "  " },
		{ Foreground = { Color = color } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = workspace .. "  " },
		{ Foreground = { Color = is_ssh and "#e0af68" or "#565f89" } },
		{ Attribute = { Intensity = is_ssh and "Bold" or "Normal" } },
		{ Text = host_text },
	}))

	-- window:set_config_overrides(is_ssh and { color_scheme = "Aurora" } or {})
	-- window:set_config_overrides(is_ssh and { color_scheme = "Catppuccin Mocha" } or {})
	window:set_config_overrides(is_ssh and { color_scheme = "Fahrenheit" } or {})
end)

-- This is where you actually apply your config choices.
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.window_close_confirmation = "NeverPrompt"
config.colors = {
	split = "#3b4261",
}

-- config.default_cursor_style = "SteadyBlock"
-- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.
config.default_cursor_style = "BlinkingUnderline"

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 20
-- config.color_scheme = "Tokyo Night (Gogh)"
-- config.color_scheme = "Tokyo Night Storm (Gogh)"
-- config.color_scheme = "Catppuccinno Mocha (Gogh)"
config.color_scheme = "tokyonight_night"

-- background opacity
config.window_background_opacity = 0.95
config.macos_window_background_blur = 25
config.window_decorations = "RESIZE" -- disable the title bar but enable the resizable border

config.native_macos_fullscreen_mode = false

-- inactive pane
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- keybindings
config.keys = {
	{
		key = "9",
		mods = "ALT",
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "1",
		mods = "ALT",
		action = wezterm.action.SwitchToWorkspace({ name = "default" }),
	},
	{
		key = "2",
		mods = "ALT",
		action = wezterm.action.SwitchToWorkspace({ name = "Storybook HENK" }),
	},
	{
		key = "3",
		mods = "ALT",
		action = wezterm.action.SwitchToWorkspace({ name = "HENK Shopify" }),
	},
	{
		key = "4",
		mods = "ALT",
		action = wezterm.action.SwitchToWorkspace({ name = "WezTerm Conf" }),
	},
	{
		key = "5",
		mods = "ALT",
		action = wezterm.action.SwitchToWorkspace({ name = "Dotfiles" }),
	},
	{
		key = "6",
		mods = "ALT",
		action = wezterm.action.SwitchToWorkspace({ name = "henk-render" }),
	},
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.SendString("clear\n"),
	},
}

-- Optional plugins: https://github.com/michaelbrusegard/awesome-wezterm
-- https://github.com/zsh-sage/toggle_terminal.wez
-- https://github.com/abidibo/wezterm-cmdpicker
-- https://github.com/bad-noodles/stack.wez

-- Finally, return the configuration to wezterm:
return config
