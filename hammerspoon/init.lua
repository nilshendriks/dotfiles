-- init.lua for Omarchy-style workflow on macOS
local windowcount = require("windowcount")
-- Caps Lock mapped to Hyper (Ctrl+Alt+Cmd) in Karabiner

-- 1️⃣ Hyper / Super definition
local super = { "ctrl", "alt", "cmd" } -- Caps Lock → Hyper
local superShift = { "ctrl", "alt", "cmd", "shift" }

hs.window.animationDuration = 0.2

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
    end
end)
hs.hotkey.bind(super, "J", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowSouth()
    end
end)
hs.hotkey.bind(super, "K", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowNorth()
    end
end)
hs.hotkey.bind(super, "L", function()
    local win = hs.window.focusedWindow()
    if win then
        win:focusWindowEast()
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
hs.hotkey.bind(superShift, "Right", function()
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

-- Super + Return → Ghostty (via bundle ID)
-- hs.hotkey.bind(super, "return", function()
--     hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")
-- end)

-- Super + Return → Ghostty with smart tiling
hs.hotkey.bind(super, "return", function()
    -- Launch or focus Ghostty
    hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")

    -- Delay to allow the app to launch
    hs.timer.doAfter(0.5, function()
        local ghosttyApp = hs.application.get("Ghostty")
        if not ghosttyApp then
            return
        end
        local ghosttyWin = ghosttyApp:mainWindow()
        if not ghosttyWin then
            return
        end

        local screen = ghosttyWin:screen()
        local frame = screen:frame()

        -- Gather all visible, standard, non-minimized windows on this screen except Ghostty
        local otherWindows = {}
        for _, win in ipairs(hs.window.visibleWindows()) do
            if
                win ~= ghosttyWin
                and win:screen() == screen
                and win:isStandard()
                and not win:isMinimized()
            then
                table.insert(otherWindows, win)
            end
        end

        -- Show alert for debugging / visual feedback
        hs.alert.show("Other windows count: " .. #otherWindows)

        if #otherWindows == 0 then
            -- Empty screen → center Ghostty, 50% width
            hs.alert.show("Empty screen: centering Ghostty")
            ghosttyWin:setFrame({
                x = frame.x + frame.w / 4,
                y = frame.y,
                w = frame.w / 2,
                h = frame.h,
            })
        elseif #otherWindows == 1 then
            -- One window → split 50/50
            local other = otherWindows[1]

            hs.alert.show("One window: splitting 50/50")
            ghosttyWin:setFrame({
                x = frame.x,
                y = frame.y,
                w = frame.w / 2,
                h = frame.h,
            })
            other:setFrame({
                x = frame.x + frame.w / 2,
                y = frame.y,
                w = frame.w / 2,
                h = frame.h,
            })
        else
            -- More than 1 window → just float Ghostty
            hs.alert.show("Multiple windows: floating Ghostty")
        end
    end)
end)

-- Super + Shift + B → default browser
hs.hotkey.bind(superShift, "B", function()
    hs.alert.show("Hotkey fired!")
    -- hs.execute("open Chrome about:blank", true) -- opens default browser
    hs.execute('open "https://example.com"', true)
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
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon Omarchy config loaded ✅")
