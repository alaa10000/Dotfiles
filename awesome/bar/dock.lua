local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local icons_handler = require("tools.icon_handler")
local naughty = require("naughty")

local separator = wibox.widget{
    markup = "|",
    fg_normal = "#fcfcfc",
    halign = "center",
    widget = wibox.widget.textbox,
}

local programs = {
    {"zen-browser", "zen-browser"},
    {"code", "code"},
    {"kitty", "kitty"},
    {"spotify", "spotify"},
    {"pcmanfm", "pcmanfm-qt"},
}


local function create_element(class, program)
    local dock_element = wibox.widget {
        {
            resize = true,
            buttons = {awful.button({},1,nil, function () awful.spawn(class) end)},
            forced_width = dpi(50),
            forced_height = dpi(50),
            image = Get_icon("Papirus", nil, program, class),
            widget = wibox.widget.imagebox,
        },
        margins = dpi(2),
        widget = wibox.container.margin

    }
    return dock_element
end

local function get_elements(pr)
    local dock_elements = { layout = wibox.layout.fixed.horizontal }

    for i, p in ipairs(pr) do
        dock_elements[i] = create_element(p[1], p[2])
      end
      return dock_elements
end

local dock_elements = get_elements(programs)


-- Main dock
local dock = awful.popup {
    widget = wibox.container.background,
    ontop = true,
    bg = "#2929292b",
    visible = false,
    maximum_height = dpi(60),
    placement = function(c)
    awful.placement.bottom(c, { margins = { top = dpi(0), bottom = dpi(5), left = 0, right = 0 } }) end,
    shape = gears.shape.rounded_rect,

}

dock:struts{
    bottom = 60
}
dock:setup {
    create_element("pavucontrol", "pavucontrol"),
    separator,
    dock_elements,
    layout = wibox.layout.fixed.horizontal
}

awful.keyboard.append_global_keybindings({
    awful.key({ modkey,}, "b", dock.visible == false,
              {description="hide dock", group="awesome"}),
})

