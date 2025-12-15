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
    init = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("TS_OrganizeImports", { clear = true }),
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function()
          -- vtsls has a different command for organize imports
          pcall(vim.lsp.buf.execute_command, {
            command = "source.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
          })
        end,
      })
    end,
    config = function(_, opts)
      require("auto-lsp").setup(opts)

      -- Specific configuration for vtsls
      local lspconfig = require "lspconfig"
      lspconfig.vtsls.setup {
        -- Make sure to attach your standard on_attach and capabilities here if needed
        -- The auto-lsp plugin usually handles this, but vtsls specific settings go here:
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"

      -- Adapter for Node.js
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
      end

      -- Adapter for Chrome (Frontend)
      if not dap.adapters["pwa-chrome"] then
        dap.adapters["pwa-chrome"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
      end

      for _, language in ipairs { "typescript", "javascript", "javascriptreact", "typescriptreact" } do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            -- Debug Node.js (Backend/Scripts)
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Current File (pwa-node)",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            -- Debug Chrome (Frontend)
            {
              type = "pwa-chrome",
              request = "launch",
              name = "Launch Chrome with 'localhost'",
              url = "http://localhost:3000", -- Default for React, change to 5173 for Vite/Vue if needed
              webRoot = "${workspaceFolder}",
              userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-profile",
            },
          }
        end
      end
    end,
  },
}
