return {
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
      require("java").setup {}
      require("lspconfig").jdtls.setup {
        on_attach = function(client, bufnr)
          require("nvchad.configs.lspconfig").on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
        settings = {
          java = {
            format = {
              enabled = false,
            },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-25",
                  path = "/Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Home",
                  default = true,
                },
                {
                  name = "JavaSE-21",
                  path = "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home",
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
        -- Use a simpler root directory detection
        root_dir = require("lspconfig.util").root_pattern(
          "settings.gradle",
          "settings.gradle.kts",
          "pom.xml",
          "build.gradle",
          "mvnw",
          "gradlew",
          ".git"
        ),
      }
    end,
  },
}
