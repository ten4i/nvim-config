-- ===============================
-- PWD (current directory)
-- ===============================
local function pwd()
  return "󰉖 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = "everforest",
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    -- lualine_c = {
    --   pwd,
    --   'filename',
    -- },
    lualine_x = {
      -- 'encoding',
      -- 'fileformat',
      'filetype',
    },
    lualine_y = { 'fileformat' },
    lualine_z = { 'location' },
  },
}

