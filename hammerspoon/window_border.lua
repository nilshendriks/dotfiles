local M = {}

local focusedBorder = nil

local function drawFocusedWindowBorder()
    if focusedBorder then
        focusedBorder:delete()
        focusedBorder = nil
    end

    local win = hs.window.focusedWindow()
    if not win then
        return
    end

    local f = win:frame()
    local borderRect = hs.geometry.rect(f.x - 3, f.y - 3, f.w + 6, f.h + 6)

    focusedBorder = hs.drawing.rectangle(borderRect)
    focusedBorder:setStrokeColor({
        red = 0,
        green = 0.643,
        blue = 0.737,
        alpha = 0.9,
    })
    focusedBorder:setFill(false)
    focusedBorder:setStrokeWidth(4)
    focusedBorder:setRoundedRectRadii(24, 24)
    focusedBorder:setLevel(hs.drawing.windowLevels.overlay)
    focusedBorder:show()
end

local function clearBorder()
    if focusedBorder then
        focusedBorder:delete()
        focusedBorder = nil
    end
end

local wf = hs.window.filter.default

wf:subscribe("windowFocused", function()
    drawFocusedWindowBorder()
end)

wf:subscribe("windowMoved", function()
    drawFocusedWindowBorder()
end)

-- wf:subscribe("windowResized", function()
--     drawFocusedWindowBorder()
-- end)

wf:subscribe("windowUnfocused", function()
    clearBorder()
end)

local lastFrame = nil

local function checkWindowFrame()
    local win = hs.window.focusedWindow()
    if not win then
        clearBorder()
        lastFrame = nil
        return
    end

    local f = win:frame()
    if not lastFrame or not f:equals(lastFrame) then
        lastFrame = f
        drawFocusedWindowBorder()
    end
end

local frameWatcher = hs.timer.new(0.1, checkWindowFrame)
frameWatcher:start()

return M
