return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre' -- uncomment for format on save
    enabled = false,
    config = function()
      require "configs.conform"
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
      },
    },
  },
  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    event = "BufRead",
    cmd = { "NvimTree", "NvimTreeToggle", "NvimTreeFocus", "NvimTreeClose" },
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      require "configs.user.nvimtree"
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    config = function()
      require "configs.user.lualine"
    end,
  },
  {
    "jayp0521/mason-null-ls.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
        lazy = true,
      },
    },
    opts = function()
      local null_ls = require "null-ls"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      require("mason-null-ls").setup {
        ensure_installed = {
          "stylua",
        },
      }

      null_ls.setup {
        debug = false,
        sources = {
          null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.diagnostics.eslint_d
        },
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = "BufRead",
    config = function()
      require "configs.user.smartsplit"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    event = "BufRead",
    config = function()
      require "configs.user.toggleterm"
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      config = function()
        require("ts_context_commentstring").setup {
          enable_autocmd = false,
        }
      end,
    },
    lazy = true,
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
}
