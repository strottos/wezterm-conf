local wezterm = require("wezterm")
local handler = require("json-file-handler")
local gen_keys = require("libraries.generate-keys")

local KEYBINDINGS = {}

function KEYBINDINGS.add_to_config(config)
    local mods = { primary = "SHIFT|CTRL", secondary = "ALT|CTRL", tertiary = "SHIFT|ALT|CTRL" }
    if string.find(wezterm.target_triple, "apple") then
        mods = { primary = "SHIFT|CTRL", secondary = "CTRL|CMD", tertiary = "SHIFT|CTRL|CMD" }
    end

    config.disable_default_key_bindings = true
    config.keys = gen_keys.gen_custom_keys(mods)
    config.key_tables = gen_keys.gen_custom_key_tables()
end

return KEYBINDINGS
