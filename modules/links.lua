local wezterm = require("wezterm")

local LINKS = {}

function LINKS.add_to_config(config)
	config.hyperlink_rules = {
		-- Default:
		{ regex = [[\b\w+://[\w.-]+\.[a-z]{2,15}\S*\b]], format = "$0" },
		-- Email addresses:
		{ regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
		-- file:// URI
		{ regex = [[\bfile://\S*\b]], format = "$0" },
		-- URLs with numeric addresses as hosts
		{ regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = "$0" },
	}
end

return LINKS
