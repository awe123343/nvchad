return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  main = "ibl",
  opts = {
    indent = {
      char = "",  -- Hide the vertical bar, just use dots from listchars
    },
    whitespace = {
      remove_blankline_trail = false,
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
  },
}
