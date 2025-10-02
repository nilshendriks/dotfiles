return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        -- Add keymaps
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Add buffer to Harpoon" })
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle Harpoon menu" })

        -- Select specific buffers (first 2 pinned buffers example)
        vim.keymap.set("n", "<C-h>", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "<C-t>", function()
            harpoon:list():select(2)
        end)

        -- Navigate next/previous
        vim.keymap.set("n", "<C-n>", function()
            harpoon:list():next()
        end)
        vim.keymap.set("n", "<C-p>", function()
            harpoon:list():prev()
        end)
    end,
}
