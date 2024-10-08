-- lua/plugins/copilot.lua
return {
  "zbirenbaum/copilot.lua",
  event = "VeryLazy", -- Load the plugin lazily
  opts = {
    auto_start = false, -- Disable Copilot on startup
    suggestion = { enabled = false }, -- Disable suggestions in completion
  },
  keys = {
    {
      "<leader>at",
      function()
        if require("copilot.client").is_disabled() then
          require("copilot.command").enable()
        else
          require("copilot.command").disable()
        end
      end,
      desc = "Toggle (Copilot)",
    },
  },
  -- { "zbirenbaum/copilot-cmp", enabled = false },
}
