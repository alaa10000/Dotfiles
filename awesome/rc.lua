--[[
    macos-dark Awesome WM config

    based on: Copland Awesome WM config 
    github.com/copycat-killer 
--]]

-- {{{ Required libraries
local awful     = require("awful")
awful.rules     = require("awful.rules")
                  require("awful.autofocus")
local beautiful = require("beautiful")
local gears     = require("gears")
local lain      = require("lain")
local spawn     = require('awful.spawn')
local wibox     = require("wibox")
-- }}}

-- {{{ Error handling
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/macos-dark/theme.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "kitty"
editor     = os.getenv("EDITOR") or "code"
editor_cmd = terminal .. " -e " .. editor

-- set gaps
beautiful.useless_gap = 5
beautiful.gap_single_client = true

-- set layouts
awful.layout.layouts = { 
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier,
    awful.layout.suit.fair,
    awful.layout.suit.tile,
}

-- quake terminal
awful.screen.connect_for_each_screen(function(s)
    -- Quake application
    s.quake = lain.util.quake()
    s.mypromptbox = awful.widget.prompt()

end)
-- }}}

-- {{{ Tags
tags = {
    names = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Menu
--mymainmenu = awful.menu.new({ items = require("freedesktop").menu.build(),
--                              theme = { height = 16, width = 130 }})
-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
markup = lain.util.markup
blue   = beautiful.fg_focus
red    = "#121212"
green  = "#848484"

-- Textclock
mytextclock = wibox.widget.textclock("<span font_weight='bold'>%a %H:%M    </span>")

-- Separators
spr = wibox.widget.textbox(' ')
small_spr = wibox.widget.textbox('<span font="Tamsyn 4"> </span>')
bar_spr = wibox.widget.textbox('<span font="Tamsyn 3"> </span>' .. markup("#333333", "|") .. '<span font="Tamsyn 3"> </span>')

-- widget for awesomebarpy
testwidget = wibox.widget.textbox('<span font="Ionicons 8"> </span>')

-- spacer
applewidget = wibox.widget.textbox('<span font="Ionicons 12">  </span>')

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}

local taglist_buttons = awful.util.table.join(
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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "Computer", myawesomemenu, beautiful.awesome_icon },
                                    { "Open terminal", terminal },
                                    { "About This Laptop", "urxvt -hold -e 'screenfetch'"},
                                    { "Software Update", "urxvt -hold -e 'yaourt -Syua --noconfirm'" },
                                    { "System Preferences", 'xfce4-settings-manager' },
                                    { "Kill X Window", '/home/neo/.dotfiles/shortcuts/xkill.sh' },
                                    { "Sleep", 'systemctl suspend' },
                                    { "Restart", 'systemctl reboot' },
                                    { "Shut Down", 'systemctl poweroff' },
                                    { "Log Out", awesome.quit } 
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            applewidget,
            mylauncher,
            applewidget,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            testwidget,
            mytextclock,
            s.mylayoutbox,
            applewidget,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Default client focus
    awful.key({ modkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ altkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "=", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

    -- Rename tag
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),


    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc( 1)  end),
    awful.key({ modkey, "Control" }, "space",  function () awful.layout.inc(-1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "q", function () spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end),

    -- MPD control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
            mpdwidget.update()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
            mpdwidget.update()
        end),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
            mpdwidget.update()
        end),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
            mpdwidget.update()
        end),

    -- Copy to clipboard
    -- awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs

    -- docker menu
    awful.key({ modkey, "Shift" }, "d", function ()
        spawn.with_shell("/home/neo/.dotfiles/shortcuts/projmenu.sh")
		end),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function () os.execute("brightnessctl s 2%+") end, 
              {description = "Brightness +2", group = "hotkeys"}),

    awful.key({}, "XF86MonBrightnessDown", function () os.execute("brightnessctl s 2%-") end, 
              {description = "Brightness -2", group = "hotkeys"}),

    -- vol
    awful.key({}, "XF86AudioRaiseVolume", function () os.execute("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+") end, 
    	      {description = "Volume +2", group = "hotkeys"}),

    awful.key({}, "XF86AudioLowerVolume", function () os.execute("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-") end, 
    	      {description = "Volume +2", group = "hotkeys"}),

    awful.key({}, "XF86AudioMute", function () os.execute("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") end, 
    	      {description = "Volume Mute", group = "hotkeys"}),

    awful.key({}, "XF86AudioMicMute", function () os.execute("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") end, 
    	      {description = "Mic Mute", group = "hotkeys"})
)

clientkeys = awful.util.table.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client                         ),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Shift"   }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n", function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky  end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     titlebars_enabled = true,
	                 size_hints_honor = false, } },
    { rule = { class = "Firefox" },
          properties = { screen = 1, tag ="2" } },
    { rule = { class = "qemu-pebble" },
          properties = { floating = true }},
    { rule = { class = "pmenu" },
          properties = { floating = true }},

    { rule = { class = "Telegram" },
          properties = { screen = 1, tag = "0" } },
    { rule = { class = "Gajim" },
          properties = { screen = 1, tag = "0" } },
    { rule = { class = "Vivaldi-stable" },
          properties = { screen = 1, tag = "2" } },
    { rule = { class = "Google-chrome" },
          properties = { screen = 1, tag = "2" } },
    { rule = { class = "Opera" },
          callback = awful.titlebar.add,
          properties = { screen = 1, tag = "2" } },
    { rule = { class = "Dunst" },
          properties = { ontop = true } },
    { rule = { class = "Plank" },
          properties = {
              border_width = "0px",
              sticky = true,
              ontop = true,
          }
    },
    { rule = { instance = "plugin-container" },
          properties = { screen = 1, tag = "1" } },

    -- placement = awful.placement.no_overlap+awful.placement.no_offscreen
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
local sloppyfocus_last = {c=nil}
client.connect_signal("manage", function (c, startup)
    -- Enable round corners with the shape api
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,6)
    end

    -- Enable sloppy focus
    client.connect_signal("mouse::enter", function(c)
         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
             -- Skip focusing the client if the mouse wasn't moved.
             if c ~= sloppyfocus_last.c then
                 client.focus = c
                 sloppyfocus_last.c = c
             end
         end
     end)

end)

-- Create titlebar
client.connect_signal("request::titlebars", function(c)
    -- Code to create your titlebar here
    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.closebutton(c))
        right_layout:add(awful.titlebar.widget.minimizebutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=22}):set_widget(layout)
    end

    -- Hide created titlebar
    if c.class == "Opera" or c.class == "Pantheon-files" then
        awful.titlebar.hide(c)
    end
end)


-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = 0

        -- no borders if only 1 client visible
        elseif #awful.client.visible(mouse.screen) > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange",
    function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))
    end)
end
-- }}}
