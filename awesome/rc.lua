local beautiful = require("beautiful")
local gears = require("gears")

dpi = beautiful.xresources.apply_dpi


require("awful.hotkeys_popup.keys")
require("awful.autofocus")

beautiful.init("~/.config/awesome/themes/xresources/theme.lua")

terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "qutebrowser"
filebrowser = "pcmanfm"
modkey = "Mod4"


require ("core.error_handling")

--require("bar.top")

require("mappings.bindings")

require("core.rules")

require("core.notifications")

require("tools.sloppy_focus")

require("tools.autostart")


require("bar.dock")
require("bar.left_bar")
require("bar.right_bar")


