-- {{{ Rules

local awful = require("awful")
local ruled = require("ruled")


-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    ruled.client.append_rule {
        rule       = { class = "kitty"     },
        properties = { titlebars_enabled = false,
        floating  = true,
        ontop  = true,
        placement = awful.placement.centered,
        width     = 460,
        height    = 280,
        }
    }

    ruled.client.append_rule {
        rule       = { class = "Plank"},
        properties = { border_width = 0, below = true}
    }

    ruled.client.append_rule {
        rule       = { class = "CrossOver"},
        properties = { border_width = 0}
    }
end)
-- }}}
