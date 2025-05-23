return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- javascript = { "eslint" },
      -- typescript = { "biomejs" },
      -- javascriptreact = { "biomejs" },
      -- typescriptreact = { "biomejs" },
      -- json = { "biomejs" },
      -- jsonc = { "biomejs" },
      -- css = { "stylelint" },
      -- html = { "htmlhint" },
      -- html = { "djlint", "htmlhint" },
      html = { "htmlhint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    -- vim.keymap.set("n", "<leader>l", function()
    --     lint.try_lint()
    -- end, { desc = "Trigger linting for current file" })
  end,
}
