return {
    "IogaMaster/tuxedo.nvim",
    cmd = { "Tuxedo" },
    keys = {
        { "<leader>t", "<cmd>Tuxedo<cr>", desc = "Toggle Tuxedo Tasks" },
    },
    config = function()
        -- 1. Inject the environment variables directly into NeoVim's global state
        vim.env.TODO_DIR = vim.fn.expand("~/dotfiles/tuxedo")
        vim.env.TODO_FILE = vim.env.TODO_DIR .. "/todo.txt"
        vim.env.DONE_FILE = vim.env.TODO_DIR .. "/done.txt"

        -- 2. Initialize the plugin settings
        require("tuxedo").setup({
            create_todo_file = false,
            width_ratio = 0.95,
            height_ratio = 0.80,
        })

        -- 3. Open tuxedo pre-filtered to your active project folder name
        vim.keymap.set("n", "<leader>tp", function()
            local project = vim.fs.basename(vim.fn.getcwd())
            vim.cmd("Tuxedo")

            -- We give the TUI 150ms to draw its layout before sending input
            vim.defer_fn(function()
                local chan_id = vim.b.terminal_job_id
                if chan_id then
                    -- Send raw stream bytes directly to tuxedo's background process
                    -- '\r' serves as the raw carriage return (Enter key)
                    vim.api.nvim_chan_send(chan_id, "/" .. "+" .. project .. "\r")
                end
            end, 150)
        end, { desc = "Tuxedo Project Tasks" })
    end,
}
