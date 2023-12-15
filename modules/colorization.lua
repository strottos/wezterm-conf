local wezterm = require("wezterm")
local handler = require("json-file-handler")

local COLORIZATION = {}

function COLORIZATION.add_to_config(config)
	local settings = handler.read(wezterm.config_dir .. "/settings.json")

	-- Lua has no way to do a switch here except for if/elseif/else/end
	local theme = settings.theme
	if theme then
		local path = wezterm.config_dir .. "/themes/" .. theme.file

		if theme.kind == "toml" then
			config.colors = wezterm.color.load_scheme(path)
		elseif theme.kind == "yaml" then
			config.colors = wezterm.color.load_base16_scheme(path)
		elseif theme.kind == "lua" then
			local imported_theme = require("themes." .. theme.name)
			config.colors = imported_theme
		elseif theme.kind == "builtin" then
			config.color_scheme = theme.name
		end
	end
end

return COLORIZATION
