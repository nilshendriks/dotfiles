return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    -- Configure how diagnostics are displayed globally
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- or "»" or "" if you want no prefix
        spacing = 2,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
    local lint = require("lint")

    ---@diagnostic disable: assign-type-mismatch
    lint.linters.oxlint = {
      name = "oxlint", -- ✅ required!
      cmd = os.getenv("HOME") .. "/.local/share/HENKVim/mason/bin/oxlint",
      stdin = false,
      args = { "-f", "json" },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, _)
        -- output is already a JSON string, no need to concat
        local ok, decoded = pcall(vim.fn.json_decode, output)
        if not ok or not decoded or type(decoded) ~= "table" then
          print("Failed to decode JSON from oxlint output")
          return {}
        end

        local diagnostics = {}
        if type(decoded.diagnostics) == "table" then
          for _, diag in ipairs(decoded.diagnostics) do
            local label = diag.labels and diag.labels[1]
            if label and label.span then
              table.insert(diagnostics, {
                lnum = label.span.line - 1,
                col = label.span.column - 1,
                message = diag.message,
                severity = ({
                  error = vim.diagnostic.severity.ERROR,
                  warning = vim.diagnostic.severity.WARN,
                  info = vim.diagnostic.severity.INFO,
                  hint = vim.diagnostic.severity.HINT,
                })[diag.severity] or vim.diagnostic.severity.WARN,
                source = "oxlint",
              })
            end
          end
        end

        return diagnostics
      end,
    }
    lint.linters_by_ft = {
      typescript = { "oxlint" },
      javascript = { "oxlint" },
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
      callback = function(args)
        lint.try_lint(nil, {
          callback = function(diagnostics)
            vim.diagnostic.set(vim.api.nvim_create_namespace("oxlint"), args.buf, diagnostics, {})
          end,
        })
      end,
      -- callback = function()
      --   print("Triggering lint...") -- Debug print
      --   lint.try_lint()
      -- end,
    })
    -- vim.keymap.set("n", "<leader>l", function()
    --     lint.try_lint()
    -- end, { desc = "Trigger linting for current file" })
  end,
}
