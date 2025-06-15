return {
  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight.disable = vim.tbl_extend("force", opts.highlight.disable or {}, { "markdown" })
    end,
  },
}
