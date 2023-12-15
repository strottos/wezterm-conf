local wezterm = require("wezterm")

local EVENT = {}

function EVENT.activate(config)
    config.default_prog = { 'pwsh' }
    config.scrollback_lines = 100000
    --config.debug_key_events = true
    --

    wezterm.on("gui-startup", function(cmd)
        local _, _, window = wezterm.mux.spawn_window(cmd or {})
        window:gui_window():maximize()
    end)
end

return EVENT
