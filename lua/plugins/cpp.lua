return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "codelldb",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cpp",
        "c",
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "cuda", "proto" },
    config = function()
      local on_attach = require("nvchad.configs.lspconfig").on_attach

      -- Custom clangd settings
      vim.lsp.config("clangd", {
        on_attach = function(client, bufnr)
          client.server_capabilities.signatureHelpProvider = false
          on_attach(client, bufnr)
          -- Enable inlay hints
          require("clangd_extensions.inlay_hints").setup_autocmd()
          require("clangd_extensions.inlay_hints").set_inlay_hints()
        end,
      })
      vim.lsp.enable "clangd"

      require("clangd_extensions").setup()
    end,
  },
}
