return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    ft = { "rust" },
    config = function()
      local on_attach = require("nvchad.configs.lspconfig").on_attach
      local capabilities = require("nvchad.configs.lspconfig").capabilities

      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Run the default on_attach
            on_attach(client, bufnr)
            -- Add keybindings specific to Rustaceanvim
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp "debuggables"
            end, { desc = "Rust Debuggables", buffer = bufnr })
          end,
          capabilities = capabilities,
        },
        dap = {
          -- rustaceanvim will automatically find the mason-installed codelldb
          -- if you need to manually specify it, uncomment and set paths below:
          -- adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb", -- Debugger
        "rust-analyzer", -- LSP
      },
    },
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
      crates.show()
    end,
  },
}
