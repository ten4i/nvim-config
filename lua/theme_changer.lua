-- =========================================================
-- 🌗 Detect GNOME system theme (light / dark)
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
  end

  return "dark"
end


-- =========================================================
-- 🎨 Transparency + UI tweaks
-- =========================================================
local function set_ui()

  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "EndOfBuffer",
    "MsgArea",
    "FoldColumn",
    "StatusLine",
    "StatusLineNC",
    "VertSplit",
    "WinSeparator",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end

  -- softer line numbers
  vim.api.nvim_set_hl(0, "LineNr", {
    fg = "#5a5a5a",
    bg = "NONE"
  })

  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#e0e0e0",
    bold = true
  })

  -- subtle cursor line
  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#242424"
  })
end


-- =========================================================
-- 🎨 Apply theme
-- =========================================================
local function apply_theme()

  local bg = get_system_theme()

  vim.o.background = bg

  if bg == "light" then
    vim.cmd.colorscheme("kanso-pearl")
  else
    vim.cmd.colorscheme("goodwolf")
  end

  set_ui()
end


-- =========================================================
-- 🔁 Reapply UI after colorscheme loads
-- =========================================================
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    set_ui()
  end,
})


-- =========================================================
-- 🚀 Execute
-- =========================================================
apply_theme()
