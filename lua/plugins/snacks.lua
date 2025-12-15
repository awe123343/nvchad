return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Core useful features
      indent = { enabled = true },
      scope = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },

      -- Performance optimizations (Safe to enable)
      bigfile = { enabled = true }, -- Disables expensive features for large files
      quickfile = { enabled = true }, -- Speeds up loading of first file

      -- Utilities
      words = { enabled = true }, -- Auto-highlights word references (like vim-illuminate)

      -- UI Components (Disabled to preserve NvChad look/feel)
      dashboard = { enabled = false }, -- NvChad has Nvdash
      explorer = { enabled = false }, -- NvChad uses nvim-tree
      picker = { enabled = false }, -- NvChad uses Telescope
      scroll = { enabled = false }, -- Smooth scrolling (optional preference)
      statuscolumn = { enabled = false }, -- Left gutter (line numbers/signs)
    },
  },
}
