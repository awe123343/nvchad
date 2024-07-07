-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local M = {}

M.setup = function(opts)
  -- lsps with default config
  local servers = opts.ensure_installed
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end

  -- typescript
  lspconfig.tsserver.setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }

  lspconfig.lua_ls.setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
      Lua = {
        format = {
          enable = false,
        },
        diagnostics = {
          globals = { "vim", "spec" },
        },
        runtime = {
          version = "LuaJIT",
          special = {
            spec = "require",
          },
        },
        -- workspace = {
        -- 	checkThirdParty = false,
        -- 	library = {
        -- 		[vim.fn.expand("$VIMRUNTIME/lua")] = true,
        -- 		[vim.fn.stdpath("config") .. "/lua"] = true,
        -- 	},
        -- },
        workspace = {
          checkThirdParty = false,
        },
        hint = {
          enable = false,
          arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
          await = true,
          paramName = "Disable", -- "All" | "Literal" | "Disable"
          paramType = true,
          semicolon = "All", -- "All" | "SameLine" | "Disable"
          setType = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

return M
