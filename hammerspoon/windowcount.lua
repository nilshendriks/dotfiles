-- ~/.hammerspoon/utils/windowcount.lua
local windowcount = {}

-- Returns the number of standard, non-minimized windows on the given screen
function windowcount.countWindowsOnScreen(screen)
    if not screen then
        screen = hs.screen.mainScreen()
    end

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

    return count
end

-- Convenience function to show an alert with the count
function windowcount.showCountAlert(screen)
    local count = windowcount.countWindowsOnScreen(screen)
    hs.alert.show("Number of windows on screen: " .. count)
end

return windowcount
