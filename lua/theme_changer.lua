-- =========================================================
-- Detect GNOME system theme
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

  result = result
    :lower()
    :gsub("[\n']", "")
    :gsub("%s+", "")

  if result:match("prefer%-light") then
    return "light"
  end

  return "dark"
end


-- =========================================================
-- Transparent background
-- =========================================================
local function transparent()

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

  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "NONE" })
  end

end


-- =========================================================
-- Apply theme
-- =========================================================
local function apply_theme()

  local bg = get_system_theme()

  vim.o.background = bg

  if bg == "light" then
    vim.cmd.colorscheme("kanso-pearl")
  else
    vim.cmd.colorscheme("kanso-mist")
  end

  transparent()

end


-- run once
apply_theme()


-- reapply transparency after colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    transparent()
  end,
})
