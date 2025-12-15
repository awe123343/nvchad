return {
  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "js-debug-adapter",
        "eslint_d",
      },
    },
  },
  {
    "pojokcodeid/auto-lsp.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Use vtsls instead of ts_ls/tsserver
      vim.list_extend(opts.ensure_installed, { "vtsls", "eslint", "html", "cssls", "jsonls" })
    end,
  },
}
