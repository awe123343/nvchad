return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").kotlin_language_server.setup {
        cmd_env = {
          JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home",
        },
        root_dir = require("lspconfig.util").root_pattern(
          "settings.gradle",
          "settings.gradle.kts",
          "build.xml",
          "pom.xml"
        ),
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
      }
    end,
  },
}
