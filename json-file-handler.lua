local wezterm = require("wezterm")

local JSON_FILE_HANDLER = {}

function JSON_FILE_HANDLER.read(path)
	local file = io.open(path, "r")

	if file then
		local contents = file:read("a")
		local json = wezterm.json_parse(contents)
		file:close()
		return json
	end

	return {}
end

function JSON_FILE_HANDLER.write(contents, path)
	local file = io.open(path, "w")

	if file then
		local json = wezterm.json_encode(contents)
		file:write(json)
		file:close()
	end
end

return JSON_FILE_HANDLER
