local keys = require("keys")
local utils = require("utils")

-- Super + Shift + A: AI: CHATGPT
hs.hotkey.bind(keys.superShift, "A", function()
    hs.application.launchOrFocus("ChatGPT")
end)

-- 2️⃣ Window Focus (H/J/K/L)
hs.hotkey.bind(keys.super, "H", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowWest()
        showFocusedAppName()
    end
end)
hs.hotkey.bind(keys.super, "J", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowSouth()
        showFocusedAppName()
    end
end)
hs.hotkey.bind(keys.super, "K", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowNorth()
        showFocusedAppName()
    end
end)
hs.hotkey.bind(keys.super, "L", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowEast()
        showFocusedAppName()
    end
end)

-- 3️⃣ Window Move (Super+Shift + arrows)
hs.layout.up50 = hs.geometry.unitrect(0, 0, 1, 0.5)
hs.layout.down50 = hs.geometry.unitrect(0, 0.5, 1, 0.5)

-- Move left with margins
hs.hotkey.bind(keys.superShift, "left", function()
    local win = hs.window.focusedWindow()
    if win then
        local margin = 8
        local screenFrame = win:screen():frame()

        local newFrame = {
            x = screenFrame.x + margin,
            y = screenFrame.y + margin,
            w = (screenFrame.w / 2) - 2 * margin,
            h = screenFrame.h - 2 * margin,
        }

        win:setFrame(newFrame)
    else
        hs.alert.show("No focused window!")
    end
end)
-- hs.hotkey.bind(keys.superShift, "left", function()
--     -- hs.alert.show("hotkey fired")
--     local win = hs.window.focusedWindow()
--     if win then
--         win:moveToUnit(hs.layout.left50)
--     else
--         hs.alert.show("No focused window!")
--     end
-- end)

-- Move right with margins
hs.hotkey.bind(keys.superShift, "right", function()
    local win = hs.window.focusedWindow()
    if win then
        local margin = 8
        local screenFrame = win:screen():frame()

        local newFrame = {
            x = screenFrame.x + (screenFrame.w / 2) + margin,
            y = screenFrame.y + margin,
            w = (screenFrame.w / 2) - 2 * margin,
            h = screenFrame.h - 2 * margin,
        }

        win:setFrame(newFrame)
    else
        hs.alert.show("No focused window!")
    end
end)

hs.hotkey.bind(keys.superShift, "Up", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit(hs.layout.up50)
    end
end)
hs.hotkey.bind(keys.superShift, "Down", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit(hs.layout.down50)
    end
end)

-- 4️⃣ App Launcher (Super + Space)
hs.hotkey.bind(keys.super, "space", function()
    hs.eventtap.keyStroke({ "cmd" }, "space")
end)

-- 5️⃣ Close window (Super + W)
hs.hotkey.bind(keys.super, "W", function()
    local win = hs.window.focusedWindow()
    if win then
        win:close()
    end
end)

-- fullscreen
hs.hotkey.bind(keys.super, "F", function()
    hs.alert.show("Toggling fullscreen")
    local win = hs.window.focusedWindow()
    if win then
        win:toggleFullScreen()
    end
end)

-- Super + Shift + M → fill window / maximize with margins
hs.hotkey.bind(keys.superShift, "M", function()
    hs.alert.show("Filling window")
    local win = hs.window.focusedWindow()
    if win then
        local margin = 8 -- pixels
        local screenFrame = win:screen():frame()

        local newFrame = {
            x = screenFrame.x + margin,
            y = screenFrame.y + margin,
            w = screenFrame.w - 2 * margin,
            h = screenFrame.h - 2 * margin,
        }

        win:setFrame(newFrame)
    end
end)

-- Super + Shift + F → Finder
hs.hotkey.bind(keys.superShift, "F", function()
    hs.application.launchOrFocus("Finder")
end)

-- Super + T → Activity Monitor
hs.hotkey.bind(keys.super, "T", function()
    hs.application.launchOrFocus("Activity Monitor")
end)

-- Super + Return → Ghostty (via bundle ID)
hs.hotkey.bind(keys.super, "return", function()
    hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")
end)

-- Super + Shift + B → default browser
hs.hotkey.bind(keys.superShift, "B", function()
    hs.application.launchOrFocusByBundleID("com.google.Chrome")
end)

-- Super + K → = Omarchy shortcuts in chromeless chrome.
-- TODO: maybe try with safari?
hs.hotkey.bind(keys.super, "K", function()
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
        local newWidth = screenFrame.w * 0.75
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
hs.hotkey.bind(keys.super, "C", function()
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
        return
    end

    local margin = 8
    local screenFrame = win:screen():frame()

    local newWidth = screenFrame.w * 0.75
    local newHeight = screenFrame.h * 0.85

    local newFrame = {
        x = screenFrame.x + (screenFrame.w - newWidth) / 2 + margin,
        y = screenFrame.y + (screenFrame.h - newHeight) / 2 + margin,
        w = newWidth - 2 * margin,
        h = newHeight - 2 * margin,
    }

    win:setFrame(newFrame)
end)

-- Bind Super + E -> Emoji picker
hs.hotkey.bind(keys.super, "E", function()
    hs.eventtap.keyStroke({ "ctrl", "cmd" }, "space")
end)

-- Super + Shift + N → new ghostty window with nvim, resized
hs.hotkey.bind(keys.superShift, "N", function()
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

hs.hotkey.bind(keys.superShift, "\\", function()
    hs.alert.show("Hotkey fired for WhichKey!")
    utils.showKeybindingsGUI()
end)

return {}
