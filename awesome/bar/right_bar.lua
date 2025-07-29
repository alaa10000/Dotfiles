local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")


mytextclock = wibox.widget{
    format = '%b %d, %H:%M',
    widget = wibox.widget.textclock
}
awful.screen.connect_for_each_screen(function(s)

    local right_bar = awful.popup {
        widget = wibox.container.background,
        ontop = true,
        bg = "#2929292b",
        visible = true,
        maximum_height = dpi(20),
        placement = function(c)
        awful.placement.top_right(c, { margins = { top = dpi(5), bottom = 0, left = dpi(5), right = 0 } }) end,
    }

    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }


    right_bar:struts {
        top = 25
    }

    right_bar:setup {
        wibox.widget.systray(),
        mytextclock,
        s.mylayoutbox,
        layout = wibox.layout.fixed.horizontal
    }
end)