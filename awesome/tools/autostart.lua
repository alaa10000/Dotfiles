-- {{{ Autostart

local awful = require("awful")

awful.spawn.with_shell('picom -b --backend glx')
awful.spawn("plank")
awful.spawn("wal -R")
-- }}}
