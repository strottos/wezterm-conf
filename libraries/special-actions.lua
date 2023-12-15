local wezterm = require("wezterm")

local SPECIAL_ACTIONS = {}

function SPECIAL_ACTIONS.ActivateExclusiveKeyTable(name)
    return wezterm.action.ActivateKeyTable({ name = name, replace_current = true })
end

function SPECIAL_ACTIONS.ActivatePersistentKeyTable(name)
    return wezterm.action.ActivateKeyTable({ name = name, replace_current = true, one_shot = false })
end

function SPECIAL_ACTIONS.SpawnProgramInNewWindow(program)
    return wezterm.action.SpawnCommandInNewWindow({
        args = { "pwsh", "-command", program },
        label = program
    })
end

SPECIAL_ACTIONS.RenameCurrentTab = wezterm.action.PromptInputLine({
    description = "Rename tab",
    action = wezterm.action_callback(function(window, _, line)
        if line then
            window:active_tab():set_title(" " .. line .. " ")
        end
    end),
})

SPECIAL_ACTIONS.ExtractToNewTab = wezterm.action_callback(function(_, pane)
    local _, _ = pane:move_to_new_tab()
end)

SPECIAL_ACTIONS.ExtractToNewWindow = wezterm.action_callback(function(_, pane)
    local _, _ = pane:move_to_new_window()
end)

SPECIAL_ACTIONS.CloseWindow = wezterm.action.InputSelector({
    title = "Close?",
    choices = {
        { id = "y", label = "Yes. (Force-close all tabs and close this window)" },
        { id = "n", label = "No." },
    },
    action = wezterm.action_callback(function(window, _, id, _)
        if id == "y" then
            local tabs = window:mux_window():tabs()

            for _, tab in pairs(tabs) do
                tab:activate()
                local pane = tab:active_pane()
                window:perform_action(wezterm.action.CloseCurrentTab({ confirm = false }), pane)
            end
        end
    end)
})

return SPECIAL_ACTIONS
