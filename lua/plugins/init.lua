return {
  {
    "pojokcodeid/auto-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("auto-conform").setup {
        ensure_installed = {
          "stylua",
        },
      }
      -- other conform config
      require("conform").setup {
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 5000,
        },
      }
    end,
  },
  {
    "pojokcodeid/auto-lint.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    event = "VeryLazy",
    config = function()
      require("auto-lint").setup {
        ensure_installed = {
          --"eslint_d",
        },
      }
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
