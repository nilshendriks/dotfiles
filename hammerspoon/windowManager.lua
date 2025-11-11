local windowManager = {}

windowManager.huds = {}

-- Create or update a HUD for a screen
function windowManager.updateHUDForScreen(screen)
    local screenUUID = screen:getUUID()

    -- get active space on this screen
    local spaceID = hs.spaces.activeSpaceOnScreen(screen)

    -- count visible windows on this space
    local windows = hs.spaces.windowsForSpace(spaceID) or {}
    local count = 0
    for _, id in ipairs(windows) do
        local win = hs.window.get(id)
        if
            win
            and win:isVisible()
            and not win:isMinimized()
            and win:isStandard()
        then
            count = count + 1
        end
    end

    -- create or update canvas HUD
    local hud = windowManager.huds[screenUUID]
    local frame = screen:fullFrame()

    if not hud then
        hud = hs.canvas.new({
            x = frame.x + (frame.w / 2) - 50,
            y = frame.y + 50,
            w = 100,
            h = 40,
        })
        windowManager.huds[screenUUID] = hud

        hud:appendElements({
            id = "background",
            type = "rectangle",
            action = "fill",
            fillColor = { white = 0, alpha = 0.5 },
            roundedRectRadii = { xRadius = 8, yRadius = 8 },
        }, {
            id = "text",
            type = "text",
            text = tostring(count),
            textColor = { white = 1 },
            textAlignment = "center",
            textFont = { name = "Menlo", size = 20 },
            frame = { x = 0, y = 0, w = 1, h = 1 },
        }):show()
    else
        -- update position and text
        hud:frame({
            x = frame.x + (frame.w / 2) - 50,
            y = frame.y + 50,
            w = 100,
            h = 40,
        })
        hud:elementText("text", tostring(count))
    end
end

-- Update HUDs on all screens
function windowManager.updateAllHUDs()
    for _, screen in ipairs(hs.screen.allScreens()) do
        windowManager.updateHUDForScreen(screen)
    end
end

-- Listen for space change, screen changes, or window focus change to update HUD
function windowManager.init()
    windowManager.updateAllHUDs()

    -- Watch for active space changes
    local spaceWatcher = hs.spaces.watcher.new(function()
        windowManager.updateAllHUDs()
    end)
    spaceWatcher:start()

    -- Watch for screen changes (display added/removed)
    local screenWatcher = hs.screen.watcher.new(function()
        windowManager.updateAllHUDs()
    end)
    screenWatcher:start()

    -- Optional: window filter to watch for visible window changes
    local wf = hs.window.filter.new(nil)
    wf:subscribe(hs.window.filter.windowVisible, function()
        windowManager.updateAllHUDs()
    end)
end

return windowManager
