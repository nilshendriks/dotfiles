-- init.lua for Omarchy-style workflow on macOS
local windowcount = require("windowcount")
-- Caps Lock mapped to Hyper (Ctrl+Alt+Cmd) in Karabiner

-- 1️⃣ Hyper / Super definition
local super = { "ctrl", "alt", "cmd" } -- Caps Lock → Hyper
local superShift = { "ctrl", "alt", "cmd", "shift" }

hs.window.animationDuration = 0

-- windowBorder = require("window_border")
local printScreen = require("print_screen")

-- Bind Hyper+P (replace `super` with your modifiers table)
printScreen.bindHotkey(super, "P")

hs.hotkey.bind(superShift, "P", function()
    -- local ok = hs.execute("screencapture -c -x", true)
    local ok = hs.execute("screencapture -c -i", true)
    if ok then
        hs.alert.show("Screenshot copied to clipboard")
    else
        hs.alert.show("Failed to capture screenshot")
    end
end)

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

-- Hotkey to show window count on main screen
hs.hotkey.bind(super, "C", function()
    windowcount.showCountAlert()
end)

-- Create a window filter that only tracks *visible* standard windows
local wf = hs.window.filter.new()
wf:setDefaultFilter({
    visible = true,
    -- currentSpace = true,
    -- allowRoles = { "AXStandardWindow" },
})

local function handleNewWindow(win, appName, event)
    if not win or not win:isVisible() or not win:isStandard() then
        return
    end
    -- small delay to ensure window is fully initialized
    hs.timer.doAfter(0.2, function()
        if win:isVisible() then
            windowcount.showCountAlert(win:screen())
        end
    end)
end

-- Subscribe to multiple events so “reused” windows still trigger
wf:subscribe({
    hs.window.filter.windowCreated,
    hs.window.filter.windowVisible,
    hs.window.filter.windowUnhidden,
}, handleNewWindow)

-- Subscribe to new visible window events
-- wf:subscribe(hs.window.filter.windowCreated, function(win, appName)
--     hs.alert.show("Window created: " .. (win:title() or "Untitled"))
--     if not win or not win:isStandard() or win:isMinimized() then
--         return
--     end
--     -- Optional: slight delay for some apps (like Slack) that need time to render
--     hs.timer.doAfter(0.2, function()
--         if win:isVisible() then
--             windowcount.showCountAlert(win:screen())
--         end
--     end)
-- end)

-- wf:subscribe(hs.window.filter.windowDestroyed, function(win, appName)
--     windowcount.showCountAlert(hs.screen.mainScreen())
-- end)

wf:subscribe(
    { hs.window.filter.windowDestroyed, hs.window.filter.windowHidden },
    function(win)
        windowcount.showCountAlert(hs.screen.mainScreen())
    end
)

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
hs.layout.up50 = hs.geometry.unitrect(0, 0, 1, 0.5)
hs.layout.down50 = hs.geometry.unitrect(0, 0.5, 1, 0.5)

hs.hotkey.bind(superShift, "left", function()
    -- hs.alert.show("hotkey fired")
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit(hs.layout.left50)
    else
        hs.alert.show("No focused window!")
    end
end)

hs.hotkey.bind(superShift, "right", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit(hs.layout.right50)
    end
end)
hs.hotkey.bind(superShift, "Up", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit(hs.layout.up50)
    end
end)
hs.hotkey.bind(superShift, "Down", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit(hs.layout.down50)
    end
end)

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

-- Super + Shift + T → new ghostty instance, resize, run fastfetch

hs.hotkey.bind(superShift, "T", function()
    hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")

    hs.timer.doAfter(0.5, function()
        local app = hs.application.get("ghostty")
        if not app then
            hs.alert.show("ghostty not running")
            return
        end

        app:activate()

        -- Capture existing windows before creating new one
        local oldWindows = app:allWindows()
        local oldWindowIDs = {}
        for _, w in ipairs(oldWindows) do
            oldWindowIDs[w:id()] = true
        end

        hs.timer.doAfter(0.3, function()
            hs.eventtap.keyStroke({ "cmd" }, "n") -- Cmd+N new window

            hs.timer.doAfter(0.5, function()
                -- Get all windows again
                local newWindows = app:allWindows()

                -- Find the new window by excluding old IDs
                local newWindow = nil
                for _, w in ipairs(newWindows) do
                    if not oldWindowIDs[w:id()] then
                        newWindow = w
                        break
                    end
                end

                -- Fallback to frontmost window if can't find new one
                if not newWindow then
                    newWindow = hs.window.frontmostWindow()
                    if newWindow:application() ~= app then
                        newWindow = nil
                    end
                end

                if not newWindow then
                    hs.alert.show("Couldn't find new ghostty window")
                    return
                end

                local screen = newWindow:screen()
                local frame = screen:frame()
                local newFrame = {
                    x = frame.x + frame.w * 0.25,
                    y = frame.y + frame.h * 0.125,
                    w = frame.w * 0.5,
                    h = frame.h * 0.75,
                }
                newWindow:setFrame(newFrame)
                newWindow:focus()

                -- Send fastfetch + Enter
                hs.eventtap.keyStrokes("fastfetch")
                hs.eventtap.keyStroke({}, "return")
            end)
        end)
    end)
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

local windowManager = require("windowManager")
windowManager.init()
