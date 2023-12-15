local wezterm = require("wezterm")

local EVENT = {}

function EVENT.activate()
    wezterm.on("update-status", function(window, _)
        local mode_labels = {
            extract_mode = "Extract",
            customize_mode = "Customize",
            resize_mode = "Resize",
            pane_mode = "Pane",
            tab_mode = "Tab",
            window_mode = "Window",
            scroll_search_mode = "Scroll/Search",
            applications_mode = "Launch",
        }
        local current_mode = window:active_key_table()
        local mode = mode_labels[current_mode]
        window:set_right_status(mode and (mode .. "  ") or "")
    end)
end

return EVENT
