-- 1️⃣ Hyper / Super definition
local super = { "ctrl", "alt", "cmd" } -- Caps Lock → Hyper
local superShift = { "ctrl", "alt", "cmd", "shift" }

hs.window.animationDuration = 0

-- Helper to show focused window’s app name
local function showFocusedAppName()
    local win = hs.window.focusedWindow()
    if win then
        local app = win:application()
        if app then
            hs.alert.show("Focus: " .. app:name(), 1) -- shows for 1 second
        end
    end
end

hs.hotkey.bind({ "shift" }, "S", function()
    hs.timer.doAfter(0, function() -- run next event loop tick
        -- local win = hs.window.focusedWindow()
        local win = hs.window.frontmostWindow()
        if win then
            local screen = win:screen():next()
            win:moveToScreen(screen)
            hs.alert.show("Moved window: " .. win:title())
        else
            hs.alert.show("No focused window")
        end
    end)
end)

-- 2️⃣ Window Focus (H/J/K/L)
hs.hotkey.bind(super, "H", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowWest()
        showFocusedAppName()
    end
end)
hs.hotkey.bind(super, "J", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowSouth()
        showFocusedAppName()
    end
end)
hs.hotkey.bind(super, "K", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowNorth()
        showFocusedAppName()
    end
end)
hs.hotkey.bind(super, "L", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowEast()
        showFocusedAppName()
    end
end)

-- 3️⃣ Window Move (Super+Shift + arrows)
-- hs.layout.up50 = hs.geometry.unitrect(0, 0, 1, 0.5)
-- hs.layout.down50 = hs.geometry.unitrect(0, 0.5, 1, 0.5)
--
-- hs.hotkey.bind(superShift, "left", function()
--     -- hs.alert.show("hotkey fired")
--     local win = hs.window.focusedWindow()
--     if win then
--         win:moveToUnit(hs.layout.left50)
--     else
--         hs.alert.show("No focused window!")
--     end
-- end)

-- hs.hotkey.bind(superShift, "right", function()
--     local win = hs.window.focusedWindow()
--     if win then
--         win:moveToUnit(hs.layout.right50)
--     end
-- end)
-- hs.hotkey.bind(superShift, "Up", function()
--     local win = hs.window.focusedWindow()
--     if win then
--         win:moveToUnit(hs.layout.up50)
--     end
-- end)
-- hs.hotkey.bind(superShift, "Down", function()
--     local win = hs.window.focusedWindow()
--     if win then
--         win:moveToUnit(hs.layout.down50)
--     end
-- end)

-- 4️⃣ App Launcher (Super + Space)
hs.hotkey.bind(super, "space", function()
    hs.eventtap.keyStroke({ "cmd" }, "space")
end)

-- 5️⃣ Close window (Super + W)
hs.hotkey.bind(super, "W", function()
    local win = hs.window.focusedWindow()
    if win then
        win:close()
    end
end)

-- Super + Shift + F → Finder
hs.hotkey.bind(superShift, "F", function()
    hs.application.launchOrFocus("Finder")
end)

-- Super + T → Activity Monitor
hs.hotkey.bind(super, "T", function()
    hs.application.launchOrFocus("Activity Monitor")
end)

-- Super + Return → Ghostty (via bundle ID)
hs.hotkey.bind(super, "return", function()
    hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")
end)

-- Super + Shift + B → default browser
hs.hotkey.bind(superShift, "B", function()
    hs.application.launchOrFocusByBundleID("com.google.Chrome")
end)

-- Super + K → = Omarchy shortcuts in chromeless chrome.
-- TODO: maybe try with safari?
hs.hotkey.bind(super, "K", function()
    hs.execute(
        'open -na "Google Chrome" --args --app="https://learn.omacom.io/2/the-omarchy-manual/53/hotkeys"'
    )

    local targetURL = "hotkeys"

    hs.timer.doAfter(0.5, function()
        local chrome = hs.appfinder.appFromName("Google Chrome")
        if not chrome then
            hs.alert.show("Google Chrome not running")
            return
        end

        local candidateWin = nil
        for _, win in ipairs(chrome:allWindows()) do
            local title = win:title()
            if title and title:lower():find(targetURL) then
                candidateWin = win
                break
            end
        end

        if not candidateWin then
            hs.alert.show("No matching window found")
            return
        end

        local screenFrame = candidateWin:screen():frame()
        local newWidth = screenFrame.w * 0.5
        local newHeight = screenFrame.h * 0.75

        local newFrame = {
            x = screenFrame.x + (screenFrame.w - newWidth) / 2,
            y = screenFrame.y + (screenFrame.h - newHeight) / 2,
            w = newWidth,
            h = newHeight,
        }

        candidateWin:setFrame(newFrame)
        candidateWin:focus()
    end)
end)

-- Super  + C → center & resize focused window
hs.hotkey.bind(super, "C", function()
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
        return
    end

    local margin = 8
    local screenFrame = win:screen():frame()

    local newWidth = screenFrame.w * 0.5
    local newHeight = screenFrame.h * 0.75

    local newFrame = {
        x = screenFrame.x + (screenFrame.w - newWidth) / 2,
        y = screenFrame.y + (screenFrame.h - newHeight) / 2,
        w = newWidth - 2 * margin,
        h = newHeight - 2 * margin,
    }

    win:setFrame(newFrame)
end)

-- Bind Super + E -> Emoji picker
hs.hotkey.bind(super, "E", function()
    hs.eventtap.keyStroke({ "ctrl", "cmd" }, "space")
end)

-- Super + Shift + N → new ghostty window with nvim, resized
hs.hotkey.bind(superShift, "N", function()
    hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")

    hs.timer.doAfter(0.5, function()
        local appleScript = [[
            tell application "ghostty"
                activate
                tell application "System Events" to keystroke "n" using {command down}
                delay 0.3
                tell application "System Events"
                    keystroke "nn"
                    key code 36 -- press return
                end
            end tell
        ]]

        local ok, output, err = hs.osascript.applescript(appleScript)
        if not ok then
            hs.alert.show("AppleScript error: " .. (err or "unknown"))
            return
        end

        hs.timer.doAfter(0.5, function()
            local app = hs.application.get("ghostty")
            if not app then
                hs.alert.show("ghostty not running")
                return
            end

            local wins = app:allWindows()
            if #wins == 0 then
                hs.alert.show("No ghostty windows")
                return
            end

            local win = wins[#wins] -- last window = new one
            local screenFrame = win:screen():frame()
            local margin = 8
            local newFrame = {
                x = screenFrame.x + margin,
                y = screenFrame.y + margin,
                w = (screenFrame.w / 2) - (2 * margin),
                h = screenFrame.h - (2 * margin),
            }

            win:setFrame(newFrame)
            win:focus()
        end)
    end)
end)

-- Super + Shift + F: finder
hs.hotkey.bind(superShift, "F", function()
    hs.alert.show("Hotkey fired!")
    hs.application.launchOrFocus("Finder")
end)

-- 6️⃣ Auto-reload config on save
function reloadConfig(files)
    local doReload = false
    for _, file in pairs(files) do
        print("File changed: " .. file)
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.alert.show("Reloading config...")
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

hs.alert.show("Config loaded ✅")

-- local windowManager = require("windowManager")
-- windowManager.init()
