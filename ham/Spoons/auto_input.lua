
---------------------------
-- auto change input method
-- ------------------------

local alert = require "hs.alert"
local application = require "hs.application"

----------------
--This is your config
----------------
en = "com.apple.keylayout.ABC"
zh = "com.apple.inputmethod.SCIM.ITABC"
en_ = "ABC"
zh_ = "简体拼音"

----------------------------
----------------------------

local function Chinese()
    -- shuangpin
    hs.keycodes.currentSourceID(zh)
end

local function English()
    -- Colemak
    hs.keycodes.currentSourceID(en)
end

-- app to expected ime config
local app2Ime = {
--English
    {'/Applications/Terminal.app', 'English'},
    {'/Applications/iTerm.app', 'English'},
		{'/Applications/Alacritty.app', 'English'},
    {'/Applications/Safari.app', 'English'},
    {'/System/Library/CoreServices/Finder.app', 'English'},
    {'/System/Library/CoreServices/Spotlight.app', 'English'},
--Chinese
    {'/Applications/Lark.app', 'Chinese'},
    -- {'/Applications/Google Chrome.app', 'Chinese'},
    {'/Applications/Brave Browser.app', 'Chinese'},
    {'/System/Applications/Messages.app', 'Chinese'},
    {'/System/Applications/Stickies.app', 'Chinese'},
}

function updateFocusAppInputMethod(appObject)
    local ime = 'English'
    local focusAppPath = appObject:path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            ime = expectedIme
            break
        end
    end

    if ime == 'English' then
        English()
				-- alert.show(en_)
    else
        Chinese()
				-- alert.show(zh_)
    end
end

-- helper hotkey to figure out the app path and name of current focused window
-- 当选中某窗口按下ctrl+command+.时会显示应用的路径等信息
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

-----------------------------------
--auto show input method when change source
-----------------------------------
function inputchange()
		if hs.keycodes.currentSourceID() == en then
			alert.closeAll()
			alert.show(en_,0.5)
		elseif hs.keycodes.currentSourceID() == zh then
			alert.closeAll()
			alert.show(zh_,0.5)
		end
end


-- Handle cursor focus and application's screen manage.
-- 窗口激活时自动切换输入法
function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        updateFocusAppInputMethod(appObject)
				-- alert.show(hs.keycodes.currentLayout())
		else
				hs.keycodes.inputSourceChanged(inputchange)
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
