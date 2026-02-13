-- Indent guides for neovim
_G.Config.later(function()
    vim.pack.add({
        { src = "https://github.com/lukas-reineke/indent-blankline.nvim", version = vim.version.range("*") },
    })
    require("ibl").setup({
        indent = {
            char = require("icons").misc.vertical_bar,
        },
        scope = {
            show_start = false,
            show_end = false,
        },
    })
end)
