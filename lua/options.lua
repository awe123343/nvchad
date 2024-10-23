require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.opt.statusline = "%#normal# "
  end,
})

-- Pengaturan Terminal
vim.api.nvim_create_augroup("neovim_terminal", { clear = true }) -- Membuat grup autocommand untuk terminal
autocmd("TermOpen", {
  group = "neovim_terminal",
  command = "startinsert | set nonumber norelativenumber | nnoremap <buffer> <C-c> i<C-c>", -- Memasuki mode insert secara otomatis dan menonaktifkan nomor baris di buffer terminal
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lazy",
  callback = function()
    vim.opt_local.number = false
  end,
})

local opt = vim.opt
opt.cmdheight = 0
