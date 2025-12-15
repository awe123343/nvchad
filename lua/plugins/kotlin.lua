return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "lspconfig"
      local configs = require "lspconfig.configs"

      if not configs.kotlin_lsp then
        configs.kotlin_lsp = {
          default_config = {
            cmd = { "kotlin-lsp" },
            filetypes = { "kotlin" },
            root_dir = lspconfig.util.root_pattern(
              "settings.gradle",
              "settings.gradle.kts",
              "build.xml",
              "pom.xml",
              ".git"
            ),
          },
        }
      end

      lspconfig.kotlin_lsp.setup {
        cmd_env = {
          JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home",
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
      }
    end,
  },
}
