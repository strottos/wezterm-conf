local wezterm = require("wezterm")
local handler = require("json-file-handler")

local THEMEDIR = wezterm.config_dir .. "/themes"
local FONTSFILE = wezterm.config_dir .. "/known/fonts.json"
local SETTINGSFILE = wezterm.config_dir .. "/settings.json"

local function select_font(window, pane)
	local known_fonts = handler.read(FONTSFILE)

	local choices = {}
	for font, _ in pairs(known_fonts) do
		table.insert(choices, { id = font, label = font })
	end
	table.sort(choices, function(a, b)
		return a.label < b.label
	end)

	window:perform_action(wezterm.action.InputSelector({
		title = "Select font",
		choices = choices,
		action = wezterm.action_callback(function(_, _, selected_font, _)
			if selected_font then
				local settings = handler.read(SETTINGSFILE)
				settings.font = { family = selected_font, harfbuzz_features = known_fonts[selected_font] }
				handler.write(settings, SETTINGSFILE)
			end
		end)
	}), pane)
end

local function select_theme(window, pane)
	local themefiles = wezterm.read_dir(THEMEDIR)
	local themes = {}
	for _, path in pairs(themefiles) do
		-- This is the operating system path separator as defined in the Lua runtime:
		local sep = package.config:sub(1, 1)
		local file = path:gsub("^.*" .. sep, "")
		local kind = file:gsub("^.*[.]", "")
		local name = file:gsub("[.]" .. kind, "")
		themes[path] = { file = file, name = name, kind = kind }
	end

	local choices = {}
	for path, theme in pairs(themes) do
		table.insert(choices, { id = path, label = theme.file })
	end
	table.sort(choices, function(a, b)
		return a.label < b.label
	end)

	window:perform_action(wezterm.action.InputSelector({
		title = "Select theme",
		choices = choices,
		action = wezterm.action_callback(function(_, _, id, _)
			if id then
				local settings = handler.read(SETTINGSFILE)

				settings.theme = themes[id]

				handler.write(settings, SETTINGSFILE)
			end
		end),
	}), pane)
end

local function enter_builtin_theme(window, pane)
	window:perform_action(wezterm.action.PromptInputLine({
		description = "Enter the name of a builtin theme or NONE to set no theme:",
		action = wezterm.action_callback(function(_, _, line)
			if line then
				local settings = handler.read(SETTINGSFILE)

				if line == "NONE" then
					settings.theme = nil
				else
					settings.theme = { file = "", name = line, kind = "builtin" }
				end

				handler.write(settings, SETTINGSFILE)
			end
		end)
	}), pane)
end

local function set_font_size(window, pane)
	window:perform_action(wezterm.action.PromptInputLine({
		description = "Set font size",
		action = wezterm.action_callback(function(_, _, line)
			local size = tonumber(line)
			if size then
				local settings = handler.read(SETTINGSFILE)
				settings.font_size = size
				handler.write(settings, SETTINGSFILE)
			end
		end),
	}), pane)
end

local function set_harfbuzz_features(window, pane)
	local settings = handler.read(SETTINGSFILE)
	local current = (settings.font or {})["family"] or "JetBrains Mono"

	local known_fonts = handler.read(FONTSFILE)

	window:perform_action(wezterm.action.PromptInputLine({
		description = "Set font features for current font (any strings separated by whitespace)",
		action = wezterm.action_callback(function(_, _, line)
			if line then
				local features = {}
				if line ~= "NONE" then
					for element in line:gmatch("%S+") do
						table.insert(features, element)
					end
				end


				known_fonts[current] = features
				handler.write(known_fonts, FONTSFILE)

				if settings.font then
					-- Modify existing
					settings.font.harfbuzz_features = features
				else
					-- Create new
					settings.font = { harfbuzz_features = features }
				end
				handler.write(settings, SETTINGSFILE)
			end
		end),
	}), pane)
end

local function toggle_ligatures(_, _)
	local settings = handler.read(SETTINGSFILE)
	local enable_ligatures = settings.enable_ligatures and true

	settings.enable_ligatures = not settings.enable_ligatures
	handler.write(settings, SETTINGSFILE)
end

local function toggle_fancy_tab_bar(_, _)
	local settings = handler.read(SETTINGSFILE)
	local tabs = settings.tabs or {}

	local fancy = tabs.fancy
	if tabs.fancy == nil then
		tabs.fancy = false
	end

	tabs.fancy = not tabs.fancy
	settings.tabs = tabs

	handler.write(settings, SETTINGSFILE)
end

local function toggle_tab_indexes(_, _)
	local settings = handler.read(SETTINGSFILE)
	local tabs = settings.tabs or {}

	local indexes = tabs.indexes
	if tabs.indexes == nil then
		tabs.indexes = false
	end

	tabs.indexes = not tabs.indexes
	settings.tabs = tabs

	handler.write(settings, SETTINGSFILE)
end

local function select_key_paradigm(window, pane)
	local choices = {
		{ id = "default", label = "Wezterm default mappings (no overrides)" },
		{ id = "zellij", label = "Zellij-style Mappings (⌘P for pane, ⌘W for window, and so on)" },
		{ id = "custom", label = "Customized keybinings (no real mnemonics)" },
	}

	window:perform_action(wezterm.action.InputSelector({
		title = "",
		choices = choices,
		action = wezterm.action_callback(function(_, _, id, _)
			if id then
				local settings = handler.read(SETTINGSFILE)
				settings.paradigm = id
				handler.write(settings, SETTINGSFILE)
			end
		end)
	}), pane)
end

local CUSTOMIZE_ACTIONS = {}

CUSTOMIZE_ACTIONS.EnterNameOfBuiltInTheme = wezterm.action_callback(enter_builtin_theme)

CUSTOMIZE_ACTIONS.SelectTheme = wezterm.action_callback(select_theme)

CUSTOMIZE_ACTIONS.SelectFont = wezterm.action_callback(select_font)

CUSTOMIZE_ACTIONS.SetFontSize = wezterm.action_callback(set_font_size)

CUSTOMIZE_ACTIONS.SetHarfbuzzFeatures = wezterm.action_callback(set_harfbuzz_features)

CUSTOMIZE_ACTIONS.ToggleLigaturesEnabled = wezterm.action_callback(toggle_ligatures)

CUSTOMIZE_ACTIONS.ToggleFancyTabBar = wezterm.action_callback(toggle_fancy_tab_bar)

CUSTOMIZE_ACTIONS.ToggleTabIndexes = wezterm.action_callback(toggle_tab_indexes)

CUSTOMIZE_ACTIONS.SelectKeyParadigm = wezterm.action_callback(select_key_paradigm)

return CUSTOMIZE_ACTIONS
