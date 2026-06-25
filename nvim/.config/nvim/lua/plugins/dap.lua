return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Auto open/close the debug UI with the session.
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- Python: point dap-python at the Mason-installed debugpy interpreter.
    local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
    if vim.fn.has("win32") == 1 then
      debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"
    end
    require("dap-python").setup(debugpy_python)

    -- C/C++: codelldb adapter (Mason-installed).
    local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
    if vim.fn.has("win32") == 1 then
      codelldb = codelldb .. ".exe"
    end
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb,
        args = { "--port", "${port}" },
      },
    }
    dap.configurations.cpp = {
      {
        name = "Launch (codelldb)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- Keymaps (function keys for control to avoid the <leader>d collision).
    local map = vim.keymap.set
    map("n", "<F5>",  function() dap.continue() end,        { desc = "DAP continue/start" })
    map("n", "<F10>", function() dap.step_over() end,       { desc = "DAP step over" })
    map("n", "<F11>", function() dap.step_into() end,       { desc = "DAP step into" })
    map("n", "<F12>", function() dap.step_out() end,        { desc = "DAP step out" })
    map("n", "<F6>",  function() dap.terminate() end,       { desc = "DAP terminate" })
    map("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
    map("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP conditional breakpoint" })
    map("n", "<leader>tu", function() dapui.toggle() end,   { desc = "DAP toggle UI" })
  end,
}
