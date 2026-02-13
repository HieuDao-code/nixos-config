-- Benchmark startup time
_G.startup_time = vim.uv.hrtime()

-- Enable the new module loader for better performance
vim.loader.enable()

-- Bootstrap with mini
vim.pack.add({ { src = "https://github.com/nvim-mini/mini.nvim" } })

-- Setup 'mini.deps' for access to `now` and `later` helpers
require("mini.deps").setup()

-- Define global config table for sharing between modules
_G.Config = {}

-- Define custom autocommand group and helper to create an autocommand.
local custom_group = vim.api.nvim_create_augroup("custom-config", {})
_G.Config.new_autocmd = function(event, opts)
    opts.group = opts.group or custom_group
    vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper
_G.Config.on_packchanged = function(plugin_name, kinds, callback, desc)
    local f = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
        if not ev.data.active then vim.cmd.packadd(plugin_name) end
        callback()
    end
    _G.Config.new_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end

-- Define lazy helpers
_G.Config.now = MiniDeps.now
_G.Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
_G.Config.later = MiniDeps.later
