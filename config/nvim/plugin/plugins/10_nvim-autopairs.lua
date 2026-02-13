-- Autopairs
-- TODO : consider https://github.com/saghen/blink.pairs once it is stable
MiniDeps.later(function()
    vim.pack.add({ { src = "https://github.com/windwp/nvim-autopairs", version = vim.version.range("*") } })
    require("nvim-autopairs").setup({})
end)
