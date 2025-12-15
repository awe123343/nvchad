return {{
  "vladdoster/remember.nvim",
  config = function(_, opts)
    require("remember").setup(opts)
  end,
  event = "BufRead"
}}
