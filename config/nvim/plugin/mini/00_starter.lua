-- Fast and flexible start screen
_G.Config.now(function()
    local icons = require("icons")

    local starter = require("mini.starter")
    starter.setup({
        evaluate_single = true,
        items = {
            {
                { name = "- " .. icons.misc.palette .. " Oil", action = "Oil", section = "Actions" },
                {
                    name = "E " .. icons.symbol_kinds.Folder .. " File Explorer",
                    action = "lua MiniFiles.open()",
                    section = "Actions",
                },
                {
                    name = "U " .. icons.misc.search .. " Update",
                    action = "lua vim.pack.update()",
                    section = "Actions",
                },
                { name = "M " .. icons.misc.toolbox .. " Mason", action = "Mason", section = "Actions" },
                { name = "Q " .. icons.misc.quit .. " Quit Neovim", action = "qall", section = "Actions" },
            },
            starter.sections.recent_files(5, true, false),
            starter.sections.sessions(5, true),
        },
        header = function() return vim.fn.execute("version"):match("[^\n]+"):gsub("NVIM", "Neovim") end,
        content_hooks = {
            starter.gen_hook.indexing("all", { "Actions" }),
            starter.gen_hook.aligning("center", "center"),
        },
    })

    _G.Config.new_autocmd("VimEnter", {
        desc = "Update footer with startup time and plugin count",
        callback = function()
            local elapsed_time = (vim.uv.hrtime() - _G.startup_time) / 1e6
            local ms = string.format("%.2f", elapsed_time)
            local plugin_count = #vim.pack.get()

            starter.config.footer = function()
                return "⚡ Neovim loaded " .. plugin_count .. " plugins in " .. ms .. " ms"
            end
            if vim.bo.filetype == "ministarter" then starter.refresh() end
        end,
    })
end)
