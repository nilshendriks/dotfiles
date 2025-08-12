return {
  {
    "folke/snacks.nvim",
    config = function()
      require("snacks").setup({
        dashboard = { enabled = true },
        explorer = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        picker = {
          enabled = true,
          ui_select = true,
        },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = true },
        image = {
          enabled = true,
          doc = {
            enabled = true,
            inline = false, -- or false to try floating window
            float = true,
            max_width = 80, -- limits image width in chars
            max_height = 40, -- limits image height in chars
            conceal = function(lang, type)
              return type == "math" -- only conceal math images
            end,
          },
          wo = {
            wrap = false,
            number = false,
            relativenumber = false,
            cursorcolumn = false,
            signcolumn = "no",
            foldcolumn = "0",
            list = false,
            spell = false,
            statuscolumn = "",
          },
        },
      })
    end,
  },
}
