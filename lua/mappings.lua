require "nvchad.mappings"

-- add yours here
-- definiskanfunction name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-- MODES
-- mormal mode = "n"
-- insert mode = "i"
-- visual mode = "v"
-- visual block mode = "x"
-- term mode = "t"
-- command mode = "c"

for _, mode in ipairs { "i", "v", "n", "x" } do
  -- duplicate line
  keymap(mode, "<S-Down>", "<cmd>t.<cr>", opts)
  keymap(mode, "<S-Up>", "<cmd>t -1<cr>", opts)
  -- save file
  keymap(mode, "<C-s>", "<cmd>silent! w<cr>", opts)
end
-- duplicate line visual block
keymap("x", "<S-Down>", ":'<,'>t'><cr>", opts)
-- move text up and down
keymap("x", "<A-Down>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-Up>", ":move '<-2<CR>gv-gv", opts)
keymap("n", "<M-Down>", "<cmd>m+<cr>", opts)
keymap("i", "<M-Down>", "<cmd>m+<cr>", opts)
keymap("n", "<M-Up>", "<cmd>m-2<cr>", opts)
keymap("i", "<M-Up>", "<cmd>m-2<cr>", opts)
-- create comment CTRL + / all mode
keymap("v", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
keymap("v", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
keymap("i", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
keymap("i", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
keymap("i", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise.current()<cr>", opts)
keymap("i", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise.current()<cr>", opts)
keymap("n", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise.current()<cr>", opts)
keymap("n", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise.current()<cr>", opts)

-- close windows
keymap("n", "q", "<cmd>q<cr>", opts)

-- DAP Core
vim.keymap.set("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
vim.keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })
vim.keymap.set("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })

-- Gopher
vim.keymap.set("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
vim.keymap.set("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })

-- Go Debugging (dap-go)
vim.keymap.set("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })
vim.keymap.set("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last go test" })

-- Python Debugging (dap-python)
vim.keymap.set("n", "<leader>dpr", function()
  require("dap-python").test_method()
end, { desc = "Debug python test method" })
