return {
  {
    "pojokcodeid/auto-lsp.nvim",
    event = { "VeryLazy", "BufReadPre", "BufNewFile", "BufRead" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      {
        "neovim/nvim-lspconfig",
        cmd = {
          "LspInfo",
          "LspInstall",
          "LspUninstall",
        },
      },
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry", -- nvim-java's registry (spring-boot-tools etc)
            "github:mason-org/mason-registry", -- default registry
          },
          ensure_installed = {
            "kotlin-lsp",
            "jdtls",
          },
          ui = {
            icons = {
              package_pending = " ",
              package_installed = "󰄳 ",
              package_uninstalled = " 󰚌",
            },
          },
        },
        config = function(_, opts)
          require("mason").setup(opts)
        end,
      },
    },
    opts = function(_, opts)
      opts.skip_config = opts.skip_config or {}
      vim.list_extend(opts.skip_config, { "kotlin_lsp", "jdtls", "vtsls", "gopls" })

      opts.ensure_installed = opts.ensure_installed or {}
      opts.automatic_installation = true
      vim.list_extend(opts.ensure_installed, { "lua_ls" })

      opts.format_on_save = false -- config format on save none-ls
      opts.virtual_text = false
      opts.timeout_ms = 5000
      return opts
    end,
    init = function()
      -- vtsls config (TypeScript/JavaScript)
      vim.lsp.config("vtsls", {
        on_attach = function(client, bufnr)
          require("nvchad.configs.lspconfig").on_attach(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
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
      })
      vim.lsp.enable "vtsls"

      -- gopls config (Go)
      vim.lsp.config("gopls", {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
      vim.lsp.enable "gopls"

      -- golangci_lint_ls disabled: golangci-lint-langserver not compatible with golangci-lint v2.x
      -- See: https://github.com/nametake/golangci-lint-langserver/issues
      -- vim.lsp.config("golangci_lint_ls", {
      --   filetypes = { "go", "gomod" },
      --   root_markers = { "go.work", "go.mod", ".git" },
      --   init_options = {
      --     command = { "golangci-lint", "run", "--output.json.path", "stdout", "--issues-exit-code=1" },
      --   },
      -- })
      -- vim.lsp.enable "golangci_lint_ls"

      -- kotlin_lsp config
      vim.lsp.config("kotlin_lsp", {
        cmd = { "kotlin-lsp" },
        cmd_env = {
          JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home",
        },
        filetypes = { "kotlin" },
        root_markers = { "settings.gradle", "settings.gradle.kts", "build.xml", "pom.xml", ".git" },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
      vim.lsp.enable "kotlin_lsp"

      -- Organize imports on save for TS/JS
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("TS_OrganizeImports", { clear = true }),
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function()
          pcall(vim.lsp.buf.execute_command, {
            command = "source.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
          })
        end,
      })
    end,
    config = function(_, opts)
      require("auto-lsp").setup(opts)
    end,
		-- stylua: ignore
		keys = {
			{ "<leader>l", "", desc = "LSP", mode = "n" },
			{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", mode = "n" },
			{ "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics", mode = "n" },
			{ "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics", mode = "n" },
			{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", mode = "n" },
			{ "<leader>lI", "<cmd>Mason<cr>", desc = "Mason", mode = "n" },
			{ "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic", mode = "n" },
			{ "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic", mode = "n" },
			{ "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "Code Lens Action", mode = "n" },
			{ "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix", mode = "n" },
			{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", mode = "n" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols", mode = "n" },
			{ "<leader>lS",	"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",	desc = "Workspace Symbols",	mode = "n"},
		},
  },
}
