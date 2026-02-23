local M = {}

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local telescope = require("telescope")

-- =========================================================
-- SMART LAYOUT
-- =========================================================

local function smart_layout(force_preview)
  local columns = vim.o.columns

  -- 🔹 Очень узкий терминал
  if columns < 90 then
    -- если force_preview = true → не используем ivy
    if not force_preview then
      return themes.get_ivy({
        previewer = false,
      })
    end

    -- fallback если нужен preview
    return {
      previewer = true,
      layout_strategy = "vertical",
      layout_config = {
        vertical = {
          preview_height = 0.5,
          prompt_position = "bottom",
        },
        width = 0.95,
        height = 0.95,
      },
    }
  end

  -- 🔹 Средний размер
  if columns < 140 then
    return {
      previewer = true,
      layout_strategy = "vertical",
      layout_config = {
        vertical = {
          preview_height = 0.5,
          prompt_position = "bottom",
        },
        width = 0.95,
        height = 0.95,
      },
    }
  end

  -- 🔹 Широкий экран
  return {
    previewer = true,
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        preview_width = 0.55,
        prompt_position = "bottom",
      },
      width = 0.9,
      height = 0.9,
    },
  }
end

-- =========================================================
-- BUILTIN PICKERS
-- =========================================================

function M.find_files()
  builtin.find_files(smart_layout())
end

function M.buffers()
  builtin.buffers(smart_layout())
end

function M.live_grep()
  builtin.live_grep(smart_layout())
end

-- =========================================================
-- FILE BROWSER (EXTENSION)
-- =========================================================

function M.file_browser()
  telescope.extensions.file_browser.file_browser(
    smart_layout(true) -- принудительно с preview
  )
end

return M

