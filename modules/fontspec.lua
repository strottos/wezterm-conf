local wezterm = require("wezterm")
local handler = require("json-file-handler")

local FONTSPEC = {}

function FONTSPEC.add_to_config(config)
	local settings = handler.read(wezterm.config_dir .. "/settings.json")

	local enable_ligatures = settings.enable_ligatures
	local no_ligatures = { "calt=0", "clig=0", "liga=0" }
	if enable_ligatures == nil then
		-- Default to ligatures enabled if it is not specified
		enable_ligatures = true
	elseif not enable_ligatures then
		-- Globally disable ligatures if you're told to
		-- This is an `elseif` so it should NOT be evaluated when the enable_ligatures flag is nil...
		config.harfbuzz_features = no_ligatures
	end

	local font = settings.font
	if font then
		local size = settings.font_size or 12.0
		local family = font.family or "JetBrains Mono"
		local harfbuzz_features = font.harfbuzz_features or {}

		config.font_size = size
		config.font = wezterm.font_with_fallback({
			{ family = family, harfbuzz_features = enable_ligatures and harfbuzz_features or no_ligatures },
			{ family = "Symbols Nerd Font Mono" },
		})
	 end
end

return FONTSPEC
