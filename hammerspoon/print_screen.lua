local M = {}

function M.bindHotkey(modifiers, key)
    hs.hotkey.bind(modifiers, key, function()
        -- Take screenshot to clipboard only
        local ok = hs.execute("screencapture -c -x", true)
        if not ok then
            hs.alert.show("screencapture failed")
            return
        end

        hs.application.launchOrFocus("Preview")

        -- Small delay to ensure Preview is front and ready
        hs.timer.doAfter(0.3, function()
            -- Simulate Cmd+N (new from clipboard)
            hs.eventtap.keyStroke({ "cmd" }, "n")

            -- Wait a bit for new window to appear
            hs.timer.doAfter(0.4, function()
                local app = hs.application.get("Preview")
                if not app then
                    hs.alert.show("Preview not running")
                    return
                end

                local win = app:mainWindow()
                if not win then
                    hs.alert.show("No active window in Preview")
                    return
                end

                -- Resize & center window on its screen
                local screenFrame = win:screen():frame()
                local newWidth = screenFrame.w * 0.5
                local newHeight = screenFrame.h * 0.75
                local newFrame = {
                    x = screenFrame.x + (screenFrame.w - newWidth) / 2,
                    y = screenFrame.y + (screenFrame.h - newHeight) / 2,
                    w = newWidth,
                    h = newHeight,
                }

                win:setFrame(newFrame)
                win:focus()
            end)
        end)
    end)
end

return M
