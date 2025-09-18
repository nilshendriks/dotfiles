-- search and replace ui
return {
    "MagicDuck/grug-far.nvim",
    opts = {},
    keys = {
        { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search & Replace (grug-far)" },
        { "<leader>sR", "<cmd>GrugFarWord<cr>", desc = "Search & Replace Word" },
    },
}
