local wezterm = require("wezterm")

local RESIZE_ACTIONS = {}

function RESIZE_ACTIONS.ResizePaneToFractionalSize(axis, denominator)
	local directions = ({
		Horizontal = {
			Next = "Right",
			Prev = "Left",
		},
		Vertical = {
			Next = "Down",
			Prev = "Up",
		},
	})[axis]

	-- "Type protection" ish for the `axis` arg
	if not directions then
		-- A type-safe nothing value to keep the error from popping up:
		return wezterm.action_callback(function(_, _) end)
	end

	return wezterm.action_callback(function(window, pane)
		local tab = window:active_tab()
		local tab_dimensions = tab:get_size()
		local t_key = (axis == "Horizontal") and "cols" or "rows"

		local pane_dimensions = pane:get_dimensions()
		local p_key = (axis == "Horizontal") and "cols" or "viewport_rows"
		local is_last_pane = tab:get_pane_direction(directions.Next) == nil

		local target_size = tab_dimensions[t_key] // denominator
		local current_size = pane_dimensions[p_key]

		if target_size > current_size then
			local direction = is_last_pane and directions.Prev or directions.Next
			local amount = target_size - current_size
			window:perform_action(wezterm.action.AdjustPaneSize({ direction, amount }), pane)
		else
			local direction = is_last_pane and directions.Next or directions.Prev
			local amount = current_size - target_size
			window:perform_action(wezterm.action.AdjustPaneSize({ direction, amount }), pane)
		end
	end)
end

RESIZE_ACTIONS.ResizeToArbitraryHorizontalFraction = wezterm.action.PromptInputLine({
	description = "Resize to nth of window width. Input n:",
	action = wezterm.action_callback(function(window, pane, line)
		if line then
			local n = tonumber(line)
			if n then
				window:perform_action(RESIZE_ACTIONS.ResizePaneToFractionalSize("Horizontal", n), pane)
			end
		end
	end)
})

RESIZE_ACTIONS.ResizeToArbitraryVerticalFraction = wezterm.action.PromptInputLine({
	description = "Resize to nth of window height. Input n:",
	action = wezterm.action_callback(function(window, pane, line)
		if line then
			local n = tonumber(line)
			if n then
				window:perform_action(RESIZE_ACTIONS.ResizePaneToFractionalSize("Vertical", n), pane)
			end
		end
	end)
})

RESIZE_ACTIONS.ResizeFractionallyOnSelectedAxis = wezterm.action.InputSelector({
	title = "Select axis",
	choices = {
		{ label = "Horizontal" },
		{ label = "Vertical" },
	},
	action = wezterm.action_callback(function(window, pane, _, label)
		if label then
			if label == "Horizontal" then
				window:perform_action(RESIZE_ACTIONS.ResizeToArbitraryHorizontalFraction, pane)
			else
				window:perform_action(RESIZE_ACTIONS.ResizeToArbitraryVerticalFraction, pane)
			end
		end
	end),
})

return RESIZE_ACTIONS
