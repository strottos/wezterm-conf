-- Credit to https://git.sr.ht/~zpm/wezterm for starting point

local config = require("wezterm").config_builder()

require("events.augment-command-palette").activate()
require("events.format-window-title").activate()
require("events.gui-startup").activate()
require("events.update-status").activate()

require("modules.behavior").add_to_config(config)
require("modules.colorization").add_to_config(config)
require("modules.fontspec").add_to_config(config)
require("modules.keybindings").add_to_config(config)
require("modules.links").add_to_config(config)

return config
