return {
  {
    "nvim-java/nvim-java",
    ft = "java", -- load when opening Java files
    config = function()
      require("java").setup {}

      -- Custom jdtls config (merged with nvim-java defaults)
      vim.lsp.config("jdtls", {
        on_attach = function(client, bufnr)
          require("nvchad.configs.lspconfig").on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          java = {
            format = { enabled = false },
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
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local root = vim.fs.root(fname, { "settings.gradle", "settings.gradle.kts", "gradlew" })
            or vim.fs.root(fname, { "build.gradle", "build.gradle.kts", "pom.xml", "build.xml" })
            or vim.fs.dirname(fname)
          on_dir(root)
        end,
      })

      vim.lsp.enable "jdtls"
    end,
  },
}
