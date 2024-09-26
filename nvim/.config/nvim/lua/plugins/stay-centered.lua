local stay_centered_enabled = true -- Track the initial state (enabled)

return {
    {
        "arnamak/stay-centered.nvim",
        keys = {
            {
                "<leader>cw",
                function()
                    local stay_centered = require("stay-centered")
                    stay_centered.toggle()

                    -- Update the tracking variable
                    stay_centered_enabled = not stay_centered_enabled

                    -- Show notification
                    local status = stay_centered_enabled and "enabled"
                        or "disabled" -- Invert status message
                    require("notify")("Stay-centered is now " .. status, "info")
                end,
                desc = "Toggle stay-centered.nvim",
            },
        },
        config = function()
            -- Optional: Configure additional settings for the stay-centered plugin if needed
        end,
    },
}
