hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)

local hyper = { "ctrl", "alt", "cmd" }

-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
-- 	hs.reload()
-- end)
-- hs.alert.show("Config loaded")

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
	up = { hyper, "up" },
	right = { hyper, "right" },
	down = { hyper, "down" },
	left = { hyper, "left" },
	fullscreen = { hyper, "f" },
	nextscreen = { hyper, "n" },
})

-- auto reload config on save
function reloadConfig(files)
	doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

-- Build mapping of spaceID -> index
local spaceIndexMap = {}

local allSpaces = hs.spaces.allSpaces()
for screen, ids in pairs(allSpaces) do
	for index, id in ipairs(ids) do
		spaceIndexMap[id] = index
	end
end

-- Create a menubar item
local spaceMenu = hs.menubar.new()
spaceMenu:setTitle("Space ?") -- placeholder until first update

-- Watcher for active space changes
local function spaceChanged()
	local activeSpace = hs.spaces.focusedSpace()
	local index = spaceIndexMap[activeSpace] or "unknown"
	print("Active space changed to: ID=" .. activeSpace .. ", Index=" .. index)
	hs.alert.show("Active space: " .. activeSpace .. " (Index " .. index .. ")")
	spaceMenu:setTitle("Space " .. index)
end

local watcher = hs.spaces.watcher.new(spaceChanged)
watcher:start()

-- Initialize menu bar immediately
spaceChanged()
