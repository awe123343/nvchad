return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {}
    end,
    -- opts = {
    --   suggestion = {
    --     -- auto_trigger = true,
    --     enabled = false,
    --   },
    --   panel = {
    --     enabled = false,
    --   },
    -- },
  },
  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
