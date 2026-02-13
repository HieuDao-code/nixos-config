-- DAP plugin to debug your code
_G.Config.later(function()
    -- Set up icons.
    local arrows = require("icons").arrows
    local icons = {
        Stopped = { "", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = "",
        BreakpointCondition = "",
        BreakpointRejected = { "", "DiagnosticError" },
        LogPoint = arrows.right,
    }
    for name, sign in pairs(icons) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define("Dap" .. name, {
      -- stylua: ignore
      text = sign[1] --[[@as string]] .. ' ',
            texthl = sign[2] or "DiagnosticInfo",
            linehl = sign[3],
            numhl = sign[3],
        })
    end

    vim.pack.add({
        {
            src = "https://github.com/mfussenegger/nvim-dap",
            -- TODO : Pin to stable version after next release
            -- version = vim.version.range '*'
        },
        { src = "https://github.com/igorlfs/nvim-dap-view" },
        { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
        { src = "https://github.com/mfussenegger/nvim-dap-python" },
    })

    local dap = require("dap")
    local dap_view = require("dap-view")
    local dap_python = require("dap-python")
    require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })

    -- Install python specific config
    dap_python.setup("uv")

    -- Basic debugging keymaps for dap-python
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", dap.toggle_breakpoint, { desc = "Set Breakpoint condition" })
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate debugging" })
    vim.keymap.set("n", "<leader>du", dap_view.toggle, { desc = "Toggle debugger" })

    -- Dap Python specific keymaps
    vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "Test Method" })
    vim.keymap.set("n", "<leader>df", dap_python.test_class, { desc = "Test Class" })
    vim.keymap.set("n", "<leader>ds", dap_python.debug_selection, { desc = "Debug Selection" })

    -- DAP View settings
    dap_view.setup({
        winbar = {
            sections = { "scopes", "watches", "exceptions", "breakpoints", "threads", "repl", "console" },
            default_section = "scopes",
            controls = {
                enabled = true,
                position = "left",
            },
        },
        windows = { position = "right" },
        -- When jumping through the call stack, try to switch to the buffer if already open in
        -- a window, else use the last window to open the buffer.
        switchbuf = "usetab,uselast",
        -- Automatically open/close the UI when a new debug session is created/closed.
        auto_toggle = true,
    })

    -- Automatically open/close the UI when a new debug session is created/closed.
    -- dap.listeners.before.attach['dap-view-config'] = dap_view.open
    -- dap.listeners.before.launch['dap-view-config'] = dap_view.open
    -- dap.listeners.before.event_terminated['dap-view-config'] = dap_view.close
    -- dap.listeners.before.event_exited['dap-view-config'] = dap_view.close
end)
