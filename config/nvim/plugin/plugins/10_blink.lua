-- Autocompletion plugin with a SIMD fuzzy matcher written in Rust
_G.Config.later(function()
    vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") } })
    require("blink.cmp").setup({
        snippets = { preset = "mini_snippets" },
        keymap = { preset = "enter" },
        appearance = {
            -- Use custom LSP icons for the completion menu
            kind_icons = require("icons").symbol_kinds,
        },
        completion = {
            menu = {
                draw = {
                    treesitter = { "lsp" },
                    columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                },
            },
            documentation = { auto_show = true },
        },
        signature = { enabled = true },
    })
end)
