
local application = require "hs.application"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local alert = require "hs.alert"
local grid = require "hs.grid"
local hints = require "hs.hints"
local applescript = require "hs.applescript"
-- require("./Spoons/auto_input")
-- hyper
local hyper = {"ctrl", "alt", "cmd"}

hs.hotkey.bind(hyper, "W", function()
  hs.alert.show("Hello World!")
end)
hs.hotkey.bind(hyper, "9", function()
    local sf = hs.screen.primaryScreen():frame()
    hs.window.focusedWindow():setFrame(hs.geometry.new(sf.x, sf.y, sf.w*4/7, sf.h))
end)

hs.hotkey.bind(hyper, "8", function()
    local sf = hs.screen.primaryScreen():frame()
    hs.window.focusedWindow():setFrame(hs.geometry.new(sf.x+sf.w*4/7, sf.y, sf.w*3/7, sf.h))
end)

hs.hotkey.bind(hyper, "0", function()
    local sf = hs.screen.primaryScreen():frame()
    hs.window.focusedWindow():setFrame(hs.geometry.new(sf.x, sf.y, sf.w, sf.h))
end)


hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."BundleID:    "
    ..hs.window.focusedWindow():application():bundleID()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())

end)
----------------------------
--apps hotkey
----------------------------

local key2App = {
		a = "Alacritty", --a for alacritty
    b = "Google Chrome", -- b for browser
    -- d = "GoldenDict", -- d for dict
    -- e = "Code", -- e for editor
    f = "Finder",
    -- g used --center babe
		l = "Lark",
		w = "Terminal",
		-- x = 'macvim',
    -- y = 'Dictionary',
    -- z = 'iTerm2',
}

for key, app in pairs(key2App) do
    hotkey.bind(
    {"alt"},
        key,
        function()
            --application.launchOrFocus(app)
            toggle_application(app)
            --hs.grid.set(hs.window.focusedWindow(), gomiddle)
        end
    )
end

-- Toggle application focus
function toggle_application(_app)
    -- finds a running applications
    local app = application.find(_app)
    if not app then
        -- application not running, launch app
        application.launchOrFocus(_app)
        return
    end
    -- application running, toggle hide/unhide
    local mainwin = app:mainWindow()
    if mainwin then
        if true == app:isFrontmost() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    else
        -- no windows, maybe hide
        if true == app:hide() then
            -- focus app
            application.launchOrFocus(_app)
        else
            -- nothing to do
        end
    end
end
