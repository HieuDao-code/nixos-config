-- Colorscheme
_G.Config.now(function()
    vim.pack.add({ { src = "https://github.com/rose-pine/neovim", name = "rose-pine.nvim" } })
    require("rose-pine").setup({
        dark_variant = "moon",
        styles = {
            italic = false,
        },
        highlight_groups = {
            -- sidekick.nvim
            SidekickDiffAdd = { link = "DiffAdd" },
            SidekickDiffContext = { bg = "overlay", blend = 20 }, -- Overlay
            SidekickDiffDelete = { link = "DiffDelete" },
        },
    })

    vim.cmd.colorscheme("rose-pine")
end)
