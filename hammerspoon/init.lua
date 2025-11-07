-- init.lua for Omarchy-style workflow on macOS
-- Caps Lock mapped to Hyper (Ctrl+Alt+Cmd) in Karabiner

-- 1️⃣ Hyper / Super definition
local super = { "ctrl", "alt", "cmd" } -- Caps Lock → Hyper
local superShift = { "ctrl", "alt", "cmd", "shift" }

hs.window.animationDuration = 0.2

-- Hotkey to show window count on main screen
hs.hotkey.bind(super, "C", function()
    local screen = hs.screen.mainScreen()
    local count = 0

    for _, win in ipairs(hs.window.visibleWindows()) do
        if
            win:screen() == screen
            and win:isStandard()
            and not win:isMinimized()
        then
            count = count + 1
        end
    end

    hs.alert.show("Number of windows on screen: " .. count)
end)

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
hs.hotkey.bind(superShift, "Left", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveOneScreenWest()
    end
end)
hs.hotkey.bind(superShift, "Right", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveOneScreenEast()
    end
end)
hs.hotkey.bind(superShift, "Up", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveOneScreenNorth()
    end
end)
hs.hotkey.bind(superShift, "Down", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveOneScreenSouth()
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
