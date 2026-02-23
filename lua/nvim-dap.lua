local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

-- === Адаптер для Python ===
dap.adapters.python = {
  type = 'executable',
  command = vim.fn.exepath('python3'), -- Python, где стоит debugpy
  args = { '-m', 'debugpy.adapter' },
}

-- === Конфигурация для запуска текущего файла ===
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    stopOnEntry = false, -- можно поставить true для теста
    console = 'integratedTerminal', -- лучше чем internalConsole
    pythonPath = function()
      local venv = os.getenv('VIRTUAL_ENV')
      if venv and #venv > 0 then
        return venv .. '/bin/python'
      else
        return vim.fn.exepath('python3')
      end
    end,
  },
}

-- === Автооткрытие UI ===
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

