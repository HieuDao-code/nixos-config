-- Obsidian 🤝 Neovim integration
_G.Config.later(function()
    vim.pack.add({ { src = "https://github.com/obsidian-nvim/obsidian.nvim", version = vim.version.range("*") } })
    require("obsidian").setup({
        legacy_commands = false,
        workspaces = {
            {
                name = "personal",
                path = "~/Documents/obsidian/personal",
                overrides = {
                    daily_notes = {
                        workdays_only = false,
                    },
                },
            },
            {
                name = "work",
                path = "~/Documents/obsidian/work",
            },
        },
        daily_notes = {
            folder = "daily",
            date_format = "%Y/%m/%Y-%m-%d",
        },
        ui = {
            enable = false,
        },
        checkbox = {
            order = { " ", "x" },
        },
    })

    _G.Config.new_autocmd("User", {
        desc = "Obsidian keymaps",
        pattern = "ObsidianNoteEnter",
        callback = function(event)
            vim.keymap.set(
                "n",
                "<localleader><localleader>",
                "<CMD>Obsidian<CR>",
                { buffer = event.buf, desc = "Open Obsidian" }
            )
            vim.keymap.set(
                "v",
                "<localleader>e",
                "<CMD>Obsidian extract_note<CR>",
                { buffer = event.buf, desc = "Extract note" }
            )
            vim.keymap.set(
                "n",
                "<localleader>q",
                "<CMD>Obsidian quick_switch<CR>",
                { buffer = event.buf, desc = "Switch note" }
            )
            vim.keymap.set(
                "n",
                "<localleader>l",
                "<CMD>Obsidian links<CR>",
                { buffer = event.buf, desc = "Links in current note" }
            )
            vim.keymap.set(
                "n",
                "<localleader>t",
                "<CMD>Obsidian today<CR>",
                { buffer = event.buf, desc = "Today's note" }
            )
            vim.keymap.set(
                "n",
                "<localleader>w",
                "<CMD>Obsidian workspace<CR>",
                { buffer = event.buf, desc = "Switch workspace" }
            )
        end,
    })
end)
