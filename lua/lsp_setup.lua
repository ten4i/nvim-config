-- =========================================================
-- LSP SETUP (works, quiet, not deprecated)
-- =========================================================

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

vim.lsp.handlers["window/showMessage"] = function(_, result)
  if result and result.type == vim.lsp.protocol.MessageType.Error then
    vim.notify(result.message, vim.log.levels.ERROR)
  end
end

-- =========================================================
-- on_attach
-- =========================================================

local function on_attach(_, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, opts)

  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, opts)
end

-- =========================================================
-- Lua
-- =========================================================
lspconfig.lua_ls.setup({
  cmd = { "/opt/lua-language-server/bin/lua-language-server" },
  on_attach = on_attach,
  root_dir = util.root_pattern(".git", ".luarc.json"),
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})


-- =========================================================
-- Python
-- =========================================================
lspconfig.pyright.setup({
  on_attach = on_attach,
  root_dir = util.root_pattern(
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    ".git"
  ),
})

