return {
  {
    "pojokcodeid/auto-lualine.nvim",
    event = { "InsertEnter", "BufRead", "BufNewFile" },
    dependencies = { "nvim-lualine/lualine.nvim" },
    config = function()
      require("auto-lualine").setup {
        -- setColor = "Eva-Dark",
        setColor = "auto",
        setOption = "triangle",
        setMode = 0,
      }
    end,
  },
}
