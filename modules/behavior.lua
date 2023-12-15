local wezterm = require("wezterm")

local BEHAVIOR = {}

function BEHAVIOR.add_to_config(config)
    config.default_prog = { 'pwsh' }
    config.scrollback_lines = 100000
    --config.debug_key_events = true
end

return BEHAVIOR
