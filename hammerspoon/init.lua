-- 1️⃣ Hyper / Super definition
local keys = require("keys")

require("utils")
-- LOAD KEYMAPS
-- package.loaded["keymaps"] = nil
require("keymaps")

hs.window.animationDuration = 0

-- Helper to show focused window’s app name
function showFocusedAppName()
    local win = hs.window.focusedWindow()
    if win then
        local app = win:application()
        if app then
            hs.alert.show("Focus: " .. app:name(), 1) -- shows for 1 second
        end
    end
end

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
