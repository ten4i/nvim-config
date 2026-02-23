local M = {}

--------------------------------------------------
-- popup window (NEAR CURSOR)
--------------------------------------------------
local function show_popup(lines)

  if not lines or #lines == 0 then
    return
  end

  ------------------------------------------------
  -- calculate popup size
  ------------------------------------------------
  local max_width = 0
  for _, line in ipairs(lines) do
    local w = vim.fn.strdisplaywidth(line)
    if w > max_width then
      max_width = w
    end
  end

  local width  = math.min(max_width + 4, 80)
  local height = math.min(#lines, 20)

  ------------------------------------------------
  -- create buffer
  ------------------------------------------------
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "translator"
  vim.bo[buf].modifiable = false

  ------------------------------------------------
  -- POSITION NEAR CURSOR
  ------------------------------------------------
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]

  -- prevent going off screen
  local ui = vim.api.nvim_list_uis()[1]

  if col + width > ui.width then
    col = col - width
  end

  if row + height > ui.height then
    row = row - height - 1
  end

------------------------------------------------
-- smart position near cursor
------------------------------------------------
local ui = vim.api.nvim_list_uis()[1]
local cursor = vim.api.nvim_win_get_cursor(0)

local cursor_row = cursor[1]
local cursor_col = cursor[2]

-- default: below cursor
local row = 1
local col = 0

-- if not enough space BELOW → show ABOVE
if cursor_row + height + 2 > ui.height then
  row = -height - 1
end

-- if not enough space RIGHT → shift left
if cursor_col + width + 2 > ui.width then
  col = -width + 1
end

local win = vim.api.nvim_open_win(buf, true, {
  relative = "cursor",
  row = row,
  col = col,
  width = width,
  height = height,
  border = "rounded",
  style = "minimal",
})

  ------------------------------------------------
  -- close keys
  ------------------------------------------------
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })

  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })
end

--------------------------------------------------
-- run translate-shell
--------------------------------------------------
local function translate(text)

  if not text or text == "" then
    return
  end

  local cmd =
    'trans -no-ansi -brief -no-auto ' ..
    vim.fn.shellescape(text) ..
    ' -t ru' 

  local result = vim.fn.systemlist(cmd)

  show_popup(result)
end

--------------------------------------------------
-- NORMAL MODE (word under cursor)
--------------------------------------------------
function M.translate_word()
  local word = vim.fn.expand("<cword>")
  translate(word)
end

--------------------------------------------------
-- VISUAL MODE (selected text)
--------------------------------------------------
function M.translate_visual()

  local start_pos = vim.fn.getpos("'<")
  local end_pos   = vim.fn.getpos("'>")

  local lines = vim.api.nvim_buf_get_lines(
    0,
    start_pos[2] - 1,
    end_pos[2],
    false
  )

  if #lines == 0 then
    return
  end

  lines[#lines] =
    string.sub(lines[#lines], 1, end_pos[3])

  lines[1] =
    string.sub(lines[1], start_pos[3])

  local text = table.concat(lines, "\n")

  translate(text)
end

return M
