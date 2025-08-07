return {
  {
    "folke/snacks.nvim",
    config = function()
      require("snacks").setup({
        dashboard = {
          keys = {
            f = {
              function()
                require("telescope.builtin").find_files({
                  find_command = {
                    "fd",
                    "--type",
                    "f",
                    "--hidden",
                    "--exclude",
                    "node_modules",
                    "--color",
                    "never",
                    "--no-require-git",
                  },
                })
              end,
              "Find files (exclude node_modules)",
            },
          },
        },
      })
    end,
  },
}
