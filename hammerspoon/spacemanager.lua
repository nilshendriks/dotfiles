-- spacemanager.lua
local hs_spaces = hs.spaces
local hs_host = hs.host
local hs_alert = hs.alert
local M = {}

-- Replace these names with the actual computer names (System Settings -> Sharing -> Computer Name)
-- Example: "Nils-Work" and "Nils-Personal"
local machineLayouts = {
    ["Work-Laptop"] = {
        -- index => { name = "Friendly name", apps = { "App A", "App B" } } (apps optional)
        [1] = { name = "Coding (Storybook)" },
        [2] = { name = "Coding (Shopify)" },
        [3] = { name = "Browsing (Jira)" },
        [4] = { name = "Communication" },
    },
    ["Personal-Laptop"] = {
        [1] = { name = "Coding" },
        [2] = { name = "Browsing" },
        [3] = { name = "Communication" },
    },
    -- default fallback if machine name not found
    ["default"] = {
        [1] = { name = "Space 1" },
    },
}

-- get current machine name
local function getMachineName()
    local f = io.popen("scutil --get LocalHostName 2>/dev/null")
    local name = f:read("*l")
    f:close()
    return name or "default"
end

-- Build a map from spaceID -> sequential index (1..n) across all displays
local function buildSpaceIndexMap()
    local map = {}
    local all = hs_spaces.allSpaces() or {}
    local index = 0
    -- iterate through displays in deterministic order (table iteration order not guaranteed,
    -- but we only need stable mapping per run; if you want display order, you can sort keys)
    for displayUUID, spaceList in pairs(all) do
        for _, spaceID in ipairs(spaceList) do
            index = index + 1
            map[spaceID] = index
        end
    end
    return map, index
end

-- get the layout for this machine
local function getLayoutForMachine()
    local name = getMachineName()
    return machineLayouts[name] or machineLayouts["default"]
end

-- check expected vs actual space count; alerts once when mismatch is detected
local mismatchNotified = false
local function checkSpaceCount(expectedCount)
    local _, actualCount = buildSpaceIndexMap()
    if
        expectedCount
        and (actualCount ~= expectedCount)
        and not mismatchNotified
    then
        hs_alert.show(
            string.format(
                "Spaces: actual=%d expected=%d",
                actualCount,
                expectedCount
            )
        )
        mismatchNotified = true
    elseif actualCount == expectedCount then
        mismatchNotified = false
    end
end

-- main function to show title/alert and return formatted name
function M.spaceChanged(spaceMenu)
    local spaceIndexMap, _ = buildSpaceIndexMap()
    local focused = hs_spaces.focusedSpace()
    local idx = spaceIndexMap[focused] or "unknown"

    local layout = getLayoutForMachine()
    local entry = nil
    if type(idx) == "number" then
        entry = layout[idx]
    end
    local name = entry and entry.name or "(no name)"

    -- update UI: show alert and update menu title if provided
    hs_alert.show("Space " .. tostring(idx) .. ": " .. name)
    if spaceMenu and spaceMenu.setTitle then
        spaceMenu:setTitle("Space " .. tostring(idx) .. ": " .. name)
    end
end

-- convenience: return number of expected spaces for current machine
function M.expectedSpaceCount()
    local layout = getLayoutForMachine()
    local count = 0
    for k, _ in pairs(layout) do
        if type(k) == "number" and k > count then
            count = k
        end
    end
    return count
end

-- helper to start watchers (space watcher + optional settings)
function M.start(spaceMenu)
    -- initial check
    checkSpaceCount(M.expectedSpaceCount())

    -- create a spaces watcher if available
    if hs_spaces.watcher then
        -- build a watcher reacting to space change events:
        -- hs.spaces.watcher.new takes a callback called when spaces change; to detect focused space changes
        local w = hs_spaces.watcher.new(function()
            -- rebuild map and update UI
            M.spaceChanged(spaceMenu)
            checkSpaceCount(M.expectedSpaceCount())
        end)
        w:start()
        M._watcher = w
    else
        hs_alert.show(
            "hs.spaces.watcher not available on this macOS / Hammerspoon"
        )
    end

    -- run once now to set initial title
    M.spaceChanged(spaceMenu)
end

-- convenience to stop watcher
function M.stop()
    if M._watcher then
        M._watcher:stop()
        M._watcher = nil
    end
end

return M
