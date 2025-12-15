return {
  {
    "pojokcodeid/auto-lsp.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "csharp_ls",
        -- "omnisharp",
      })
    end,
  },
  -- csharpls-extended for decompilation support (csharp_ls)
  {
    "Decodetalkers/csharpls-extended-lsp.nvim",
    ft = "cs",
    config = function()
      require("csharpls_extended").buf_read_cmd_bind()
    end,
  },
  -- omnisharp-extended for decompilation support
  -- { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Inlay hints for C# LSPs (NvChad doesn't auto-enable)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or (client.name ~= "omnisharp" and client.name ~= "csharp_ls") then
            return
          end

          local bufnr = args.buf
          local function enable_inlay_hints()
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end
            -- Just enable directly - don't wait for capability
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
          -- Try immediately and again after delay
          enable_inlay_hints()
          vim.defer_fn(enable_inlay_hints, 2000)
          vim.defer_fn(enable_inlay_hints, 5000)
        end,
      })
    end,
    -- opts = {
    --   servers = {
    --     omnisharp = {
    --       handlers = {
    --         ["textDocument/definition"] = function(...)
    --           return require("omnisharp_extended").handler(...)
    --         end,
    --       },
    --       keys = {
    --         {
    --           "gd",
    --           pcall(require, "telescope") and function()
    --             require("omnisharp_extended").telescope_lsp_definitions()
    --           end or function()
    --             require("omnisharp_extended").lsp_definitions()
    --           end,
    --           desc = "Goto Definition",
    --         },
    --       },
    --       enable_roslyn_analyzers = true,
    --       organize_imports_on_format = true,
    --       enable_import_completion = true,
    --     },
    --   },
    -- },
  },
  -- Debugging support (netcoredbg)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- "csharpier",
        "csharp_ls",
        -- "omnisharp",
        "netcoredbg",
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"

      dap.adapters["netcoredbg"] = dap.adapters["netcoredbg"]
        or {
          type = "executable",
          command = vim.fn.exepath "netcoredbg",
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }

      local config = {
        {
          type = "netcoredbg",
          name = "Launch file",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      for _, lang in ipairs { "cs", "fsharp", "vb" } do
        dap.configurations[lang] = dap.configurations[lang] or config
      end
    end,
  },
}
