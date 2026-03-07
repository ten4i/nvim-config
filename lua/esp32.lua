local M = {}

function M.upload()

  local file = vim.fn.expand("%:p")
  local dir  = vim.fn.fnamemodify(file, ":h")

  vim.fn.termopen({
    dir .. "/Esp32SyncUpload.sh",
    file
  }, {
    cwd = dir
  })

end


function M.monitor()

  vim.cmd("terminal arduino-cli monitor -p /dev/ttyUSB0 -c baudrate=115200")

end

return M
