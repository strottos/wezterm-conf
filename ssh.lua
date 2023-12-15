local wezterm = require("wezterm")
local act = wezterm.action

local EVENT = {}

function EVENT.activate(config)
    config.ssh_domains = {
        {
            -- This name identifies the domain
            name = 'server',
            -- The hostname or address to connect to. Will be used to match settings
            -- from your ssh config file
            remote_address = '192.168.1.169',
            -- The username to use on the remote host
            username = 'strotter',
        },
    }
end

return EVENT
