local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")



myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                     { "open terminal", terminal }}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.tile.bottom,
    })
end)


screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
            image                 = beautiful.wallpaper,
            widget                = wibox.widget.imagebox,
        }
    }
end)


awful.screen.connect_for_each_screen(function(s)

    local left_bar = awful.popup {
        widget = wibox.container.background,
        ontop = true,
        bg = "#2929292b",
        visible = true,
        maximum_height = dpi(20),
        placement = function(c)
        awful.placement.top_left(c, { margins = { top = dpi(5), bottom = 0, left = dpi(5), right = 0 } }) end,
    }

    left_bar:struts {
        top = 25
    }



    -- Each screen has its own tag table.
    awful.tag({ "󰋜 ", " ", " " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }


    local separator = wibox.widget{
        markup = "HEYYYY",
        fg_normal = "#fcfcfc",
        halign = "center",
        widget = wibox.widget.textbox,
    }

    left_bar:setup {
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
        layout = wibox.layout.fixed.horizontal
    }
end)