return {
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   ft = { "java", "kt" },
  -- },
  {
    "nvim-java/nvim-java",
    lazy = false,
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
    config = function()
      -- require("java").setup {}
      require("lspconfig").jdtls.setup {
        -- require("java").setup {
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home",
                  default = true,
                },
                {
                  name = "JavaSE-17",
                  path = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home",
                },
                {
                  name = "JavaSE-11",
                  path = "/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home",
                },
                {
                  name = "JavaSE-1.8",
                  path = "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home",
                },
              },
            },
          },
        },
        -- on_attach = require("nvchad.configs.lspconfig").on_attach,
        -- capabilities = require("nvchad.configs.lspconfig").capabilities,
        filetypes = { "java" },
      }
    end,
  },
}
