return {
  -- nvim-lint for golangci-lint (golangci-lint-langserver doesn't support v2.x)
  {
    "mfussenegger/nvim-lint",
    ft = "go",
    config = function()
      require("lint").linters_by_ft = {
        go = { "golangcilint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        pattern = { "*.go" },
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      -- require("core.utils").load_mappings("dap_go")
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      -- require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "delve",
        "golangci-lint",
        "gotests",
      },
    },
  },
  {
    "pojokcodeid/auto-lsp.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gopls" })
    end,
  },
}
