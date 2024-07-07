local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end
local icons = require "icons"
local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

-- end for lsp
local lsp_info = {
  function()
    local msg = "LS Inactive"
    local buf_ft = vim.bo.filetype
    -- start register
    local buf_clients = vim.lsp.buf_get_clients()
    local buf_client_names = {}
    if next(buf_clients) == nil then
      -- TODO: clean up this if statement
      if type(msg) == "boolean" or #msg == 0 then
        return "LS Inactive"
      end
      return msg
    end
    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" and client.name ~= "copilot" then
        table.insert(buf_client_names, client.name)
      end
    end
    -- add conform.nvim
    local status, conform = pcall(require, "conform")
    if status then
      local formatters = conform.list_formatters_for_buffer()
      if formatters and #formatters > 0 then
        vim.list_extend(buf_client_names, formatters)
      else
        -- check if lspformat
        local lsp_format = require "conform.lsp_format"
        local bufnr = vim.api.nvim_get_current_buf()
        local lsp_clients = lsp_format.get_format_clients { bufnr = bufnr }

        if not vim.tbl_isempty(lsp_clients) then
          table.insert(buf_client_names, "lsp_fmt")
        end
      end
    else
      table.insert(buf_client_names, "lsp_fmt")
    end
    -- cek nvimlint
    local lint_s, lint = pcall(require, "lint")
    if lint_s then
      for ft_k, ft_v in pairs(lint.linters_by_ft) do
        if type(ft_v) == "table" then
          for _, ltr in ipairs(ft_v) do
            if buf_ft == ft_k then
              table.insert(buf_client_names, ltr)
            end
          end
        elseif type(ft_v) == "string" then
          if buf_ft == ft_k then
            table.insert(buf_client_names, ft_v)
          end
        end
      end
    end
    -- decomple
    local unique_client_names = vim.fn.uniq(buf_client_names)
    msg = table.concat(unique_client_names, ", ")
    return msg
  end,
  --icon = " ",
  icon = icons.ui.Gear .. "",
  padding = 1,
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  -- symbols = { error = " ", warn = " " },
  symbols = {
    error = icons.diagnostics.BoldError .. " ",
    warn = icons.diagnostics.BoldWarning .. " ",
  },
  colored = true,
  update_in_insert = false,
  always_visible = false,
}

local diff = {
  "diff",
  colored = true,
  -- symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  symbols = {
    added = icons.git.LineAdded .. " ",
    modified = icons.git.LineModified .. " ",
    removed = icons.git.LineRemoved .. " ",
  }, -- changes diff symbols
  cond = hide_in_width,
}

local spaces = function()
  -- return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  return icons.ui.Tab .. " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local mode = {
  "mode",
  padding = 1,
  separator = { left = " " },
  -- right_padding = 3,
  fmt = function(str)
    return " " .. str
  end,
}
local branch = {
  "branch",
  padding = 1,
}

local get_branch = function()
  if vim.b.gitsigns_head ~= nil then
    return " " .. vim.b.gitsigns_head
  else
    return " " .. vim.fn.fnamemodify("null", ":t")
  end
end

-- stylua: ignore
local colors = {
  blue              = '#9ece6a',
  cyan              = '#bb9af7',
  black             = '#1a1b26',
  black_transparant = '#1a1b2600',
  white             = '#c6c6c6',
  red               = "#ff757f",
  skyblue           = '#7aa2f7',
  grey              = '#3b4261',
  yellow            = "#ffc777",
  fg_gutter         = "#3b4261",
  green1            = "#4fd6be",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.skyblue },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white, bg = colors.black_transparant },
  },

  insert = {
    a = { fg = colors.black, bg = colors.blue },
    b = { fg = colors.blue, bg = colors.grey },
  },
  visual = {
    a = { fg = colors.black, bg = colors.cyan },
    b = { fg = colors.cyan, bg = colors.grey },
  },
  replace = {
    a = { bg = colors.red, fg = colors.black },
    b = { bg = colors.fg_gutter, fg = colors.red },
  },
  command = {
    a = { bg = colors.yellow, fg = colors.black },
    b = { bg = colors.fg_gutter, fg = colors.yellow },
  },
  terminal = {
    a = { bg = colors.green1, fg = colors.black },
    b = { bg = colors.fg_gutter, fg = colors.green1 },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.black_transparant },
    b = { fg = colors.white, bg = colors.black_transparant },
    c = { fg = colors.black, bg = colors.black_transparant },
  },
}

lualine.setup {
  options = {
    theme = bubbles_theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      "TelescopePrompt",
      "packer",
      "alpha",
      "dashboard",
      "NvimTree",
      "Outline",
      "DressingInput",
      "toggleterm",
      "lazy",
      "mason",
      "neo-tree",
      "nvdash",
    },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {
      mode,
    },
    lualine_b = { get_branch },
    lualine_c = { lsp_info, diagnostics },
    lualine_x = { diff, spaces, "filetype" },
    lualine_y = { "progress" },
    lualine_z = {
      { "location", separator = { right = " " }, padding = 1 },
    },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = {},
}
