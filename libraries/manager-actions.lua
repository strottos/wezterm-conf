local wezterm = require("wezterm")
local handler = require("json-file-handler")

local FONTSFILE = wezterm.config_dir .. "/known/fonts.json"

local function deregister_font(window, pane)
	local known_fonts = handler.read(FONTSFILE)

	local choices = {}
	for font, _ in pairs(known_fonts) do
		table.insert(choices, { id = font, label = font })
	end

	window:perform_action(wezterm.action.InputSelector({
		title = "Deregister font",
		choices = choices,
		action = wezterm.action_callback(function(_, _, id, _)
			if id then
				known_fonts[id] = nil
				handler.write(known_fonts, FONTSFILE)
			end
		end)
	}), pane)
end

local function register_font(window, pane)
	window:perform_action(wezterm.action.PromptInputLine({
		description = "Register a font with the list of known fonts",
		action = wezterm.action_callback(function(_, _, line)
			if line then
				local known_fonts = handler.read(FONTSFILE)

				known_fonts[line] = {}

				handler.write(known_fonts, FONTSFILE)
			end
		end),
	}), pane)
end

local function automatically_register_computer_fonts(window, pane)
	-- Spaces are important here; should be fc-list<space>:spacing=100<space>:<space>family
	 local raw = io.popen("fc-list :spacing=100 : family")
	 local output = raw:read("*a")

	 -- Build a `set` of font families
	 local computer_fonts = {}
	 for line in output:gmatch("[^\r\n]+") do
		 local trim = line:gsub(",.*$", "")
		 computer_fonts[trim] = true
	 end
	 -- wezterm.log_info(computer_fonts)

	 local description = {
		 { Text = "Register all known fonts from the local computer?\n" },
		 { Text = "These fonts will be augmented to the existing registered fonts.\n" },
		 { Text = "(You may remove unwanted fonts by unregistering them.)\n" },
		 { Attribute = { Intensity = "Bold" } },
		 { Text = "Type YES to confirm the action." },
	 }

	 window:perform_action(wezterm.action.PromptInputLine({
		 description = wezterm.format(description),
		 action = wezterm.action_callback(function(_, _, line)
			 if line == "YES" then
				 local known_fonts = handler.read(FONTSFILE)

				 for font, _ in pairs(computer_fonts) do
					 -- wezterm.log_info(font)
					 if known_fonts[font] == nil then
						 known_fonts[font] = {}
					 end
					 -- wezterm.log_info(known_fonts)
				 end

				 handler.write(known_fonts, FONTSFILE)
			 end
		 end),
	 }), pane)
end

local MANAGER_ACTIONS = {
	DeRegisterFont = wezterm.action_callback(deregister_font),
	RegisterFont = wezterm.action_callback(register_font),
	RegisterComputerFonts = wezterm.action_callback(automatically_register_computer_fonts),
}

return MANAGER_ACTIONS
