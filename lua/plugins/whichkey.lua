return {
  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`", "c", "v" },
    event = "VeryLazy",
    config = function()
      function _LAZYGIT_TOGGLE()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new { cmd = "lazygit", hidden = true }
        lazygit:toggle()
      end

      local icons = require "icons"
      -- add yours here

      -- function for close all bufferline
      function _CLOSE_ALL_BUFFER()
        require("nvchad.tabufline").closeOtherBufs()
      end

      function _CLOSE_BUF_LEFT()
        require("nvchad.tabufline").closeBufs_at_direction "left"
      end

      function _CLOSE_BUF_RIGHT()
        require("nvchad.tabufline").closeBufs_at_direction "right"
      end

      dofile(vim.g.base46_cache .. "whichkey")
      local status_ok, which_key = pcall(require, "which-key")
      if not status_ok then
        return
      end

      local setup = {

        icons = {
          rules = false,
          breadcrumb = icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
          separator = icons.ui.BoldArrowRight, -- symbol used between a key and it's label
          group = icons.ui.Plus, -- symbol prepended to a group
        },

        win = {
          row = -1,
          border = "rounded", -- none, single, double, shadow
          padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
          title = true,
          title_pos = "center",
          zindex = 1000,
          -- Additional vim.wo and vim.bo options
          bo = {},
          wo = {
            -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
          },
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },

        disable = {
          buftypes = {},
          filetypes = { "TelescopePrompt" },
        },
        ---@type false | "classic" | "modern" | "helix"
        preset = "classic",
      }
      which_key.setup(setup)
      which_key.add {
        { "<leader>b", "", desc = " Buffers" },
        { "<leader>bb", "<cmd>enew<CR>", desc = "Buffer New" },
        { "<leader>bc", "<cmd>lua  require('nvchad.tabufline').close_buffer()<cr>", desc = "Close current buffer" },
        { "<leader>bd", "<cmd>lua _CLOSE_ALL_BUFFER()<cr>", desc = "Close All Buffers" },
        { "<leader>bk", "<cmd>lua _CLOSE_BUF_LEFT()<cr>", desc = "Delete Buffer Left" },
        { "<leader>bK", "<cmd>lua _CLOSE_BUF_RIGHT()<cr>", desc = "Delete Buffer Right" },
      }
    end,
  },
}
