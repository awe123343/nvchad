return {
  "pojokcodeid/auto-conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "stevearc/conform.nvim",
  },
  event = "VeryLazy",
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Lua
    opts.formatters_by_ft["lua"] = { "stylua" }

    -- Go
    opts.formatters_by_ft["go"] = { "gofumpt", "goimports-reviser", "golines" }

    -- Python
    opts.formatters_by_ft["python"] = { "ruff_format" }

    -- Rust
    opts.formatters_by_ft["rust"] = { "rustfmt" }

    -- JavaScript / TypeScript / Web
    local js_formatters = { "prettier" }
    opts.formatters_by_ft["javascript"] = js_formatters
    opts.formatters_by_ft["typescript"] = js_formatters
    opts.formatters_by_ft["javascriptreact"] = js_formatters
    opts.formatters_by_ft["typescriptreact"] = js_formatters
    opts.formatters_by_ft["json"] = { "prettier" }
    opts.formatters_by_ft["html"] = { "prettier" }
    opts.formatters_by_ft["css"] = { "prettier" }
    opts.formatters_by_ft["scss"] = { "prettier" }

    -- Ensure Installed
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "stylua",
      "gofumpt",
      "goimports-reviser",
      "golines",
      "ruff",
      "prettier",
    })

    opts.lang_maps = opts.lang_maps or {}
    opts.name_maps = opts.name_maps or {}
    opts.add_new = opts.add_new or {}
    opts.ignore = opts.ignore or {}
  end,
  config = function(_, opts)
    require("auto-conform").setup(opts)
    -- other conform config
    local conform = require "conform"
    conform.setup {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          lsp_fallback = true,
          timeout_ms = 5000,
        }
      end,
    }

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Enable autoformat-on-save",
    })

    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 5000,
      }
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
