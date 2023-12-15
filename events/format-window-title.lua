local wezterm = require("wezterm")

local EVENT = {}

function EVENT.activate()
	wezterm.on("format-window-title", function(_, _, _, _, _)
		return ""
	end)
end

return EVENT
