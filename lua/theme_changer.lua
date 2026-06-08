local function get_system_theme()
  local handle = io.popen(
    "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null"
  )
  if not handle then return "dark" end
  local result = handle:read("*a") or ""
  handle:close()
  result = result:lower():gsub("[\n']", ""):gsub("%s+", "")
  if result:match("prefer%-light") then return "light" end
  return "dark"
end

local function set_transparent_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
end

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.o.background = get_system_theme()
    set_transparent_bg()
  end,
})

set_transparent_bg()
