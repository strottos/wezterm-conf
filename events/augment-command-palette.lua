local wezterm = require("wezterm")
local special_action = require("libraries.special-actions")
local resize_action = require("libraries.resize-actions")
local customize_action = require("libraries.customize-actions")
local manager_action = require("libraries.manager-actions")

local EVENT = {}

function EVENT.activate()
	wezterm.on("augment-command-palette", function(_, _)
		return {
			-- Add special actions:
			{ brief = "Rename current tab", action = special_action.RenameCurrentTab, icon = "md_rename_box" },
			{ brief = "Open lazygit", action = special_action.SpawnProgramInNewWindow("lazygit"), icon = "dev_git" },
			{ brief = "Open monitoring", action = special_action.SpawnProgramInNewWindow("btm"), icon = "fa_bar_chart" },
			{ brief = "Select key paradigm", action = customize_action.SelectKeyParadigm, icon = "md_keyboard" },
			-- Resizing actions:
			{ brief = "Resize to 1/2 width", action = resize_action.ResizePaneToFractionalSize("Horizontal", 2), icon = "md_table_column_width" },
			{ brief = "Resize of 1/2 height", action = resize_action.ResizePaneToFractionalSize("Vertical", 2), icon = "md_table_row_height" },
			{ brief = "Resize to 1/3 width", action = resize_action.ResizePaneToFractionalSize("Horizontal", 3), icon = "md_table_column_width" },
			{ brief = "Resize of 1/3 height", action = resize_action.ResizePaneToFractionalSize("Vertical", 3), icon = "md_table_row_height" },
			{ brief = "Resize to 1/4 width", action = resize_action.ResizePaneToFractionalSize("Horizontal", 4), icon = "md_table_column_width" },
			{ brief = "Resize of 1/4 height", action = resize_action.ResizePaneToFractionalSize("Vertical", 4), icon = "md_table_row_height" },
			{ brief = "Resize to arbitary fraction of width", action = resize_action.ResizeToArbitraryHorizontalFraction, icon = "md_table_column_width" },
			{ brief = "Resize to arbitary fraction of height", action = resize_action.ResizeToArbitraryVerticalFraction, icon = "md_table_row_height" },
			-- Visual settings:
			{ brief = "Select theme", action = customize_action.SelectTheme, icon = "md_format_paint" },
			{ brief = "Input theme name for builtin theme", action = customize_action.EnterNameOfBuiltInTheme, icon = "md_format_paint" },
			{ brief = "Select font", action = customize_action.SelectFont, icon = "md_format_font" },
			{ brief = "Deregister a font", action = manager_action.DeRegisterFont, icon = "md_format_font" },
			{ brief = "Register a font", action = manager_action.RegisterFont, icon = "md_format_font" },
			{ brief = "Automatically register fonts on this computer", action = manager_action.RegisterComputerFonts, icon = "md_format_font" },
			{ brief = "Set font size", action = customize_action.SetFontSize, icon = "cod_text_size" },
			{ brief = "Set Harfbuzz features for current font", action = customize_action.SetHarfbuzzFeatures, icon = "md_shape" },
			{ brief = "Toggle ligatures on/off globally", action = customize_action.ToggleLigaturesEnabled, icon = "md_shape" },
			{ brief = "Toggle fancy tab bar", action = customize_action.ToggleFancyTabBar, icon = "md_tab_search" },
			{ brief = "Toggle tab indexes", action = customize_action.ToggleTabIndexes, icon = "md_tab_search" },
		}
	end)
end

return EVENT
