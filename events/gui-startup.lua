local wezterm = require("wezterm")

local EVENT = {}

function EVENT.activate()
	wezterm.on("gui-startup", function(cmd)
		local _, _, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():maximize()
	end)
end

return EVENT
