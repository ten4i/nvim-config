local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("Failed to load module '" .. module .. "': " .. err, vim.log.levels.ERROR)
  else
    vim.notify("Loaded module '" .. module .. "'", vim.log.levels.INFO)
  end
end

safe_require("autocomplete")
safe_require("diagnostic")
safe_require("lines")
safe_require("nvim-dap")
safe_require("theme_changer")

