-- =========================================================
-- 🌗 Detect GNOME color scheme
-- =========================================================
local function get_system_theme()
  local handle = io.popen(
    "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null"
  )
  if not handle then
    return "dark"
  end

  local result = handle:read("*a") or ""
  handle:close()

  result = result:lower():gsub("[\n']", ""):gsub("%s+", "")

  if result:match("prefer%-light") then
    return "light"
  else
    return "dark"
  end
end

local theme = get_system_theme()

-- =========================================================
-- 🎨 Everforest setup (IMPORTANT: BEFORE colorscheme)
-- =========================================================
vim.opt.termguicolors = true

vim.g.everforest_background = "soft"        -- soft | medium | hard
vim.g.everforest_enable_italic = 1
vim.g.everforest_disable_italic_comment = 0
vim.g.everforest_ui_contrast = "high"
vim.g.everforest_diagnostic_text_highlight = 1
vim.g.everforest_diagnostic_line_highlight = 0
vim.g.everforest_transparent_background = 1

-- =========================================================
-- 🌗 Apply background
-- =========================================================
if theme == "light" then
  vim.o.background = "light"
else
  vim.o.background = "dark"
end

vim.cmd("colorscheme everforest")

-- =========================================================
-- 🔢 Cursorline (leave everforest colors)
-- =========================================================
vim.opt.cursorline = true

-- =========================================================
-- 🧱 indent-blankline / ibl.nvim (safe tweak)
-- =========================================================
vim.api.nvim_set_hl(0, "IblScope", { fg = "#5A5A5A" })

