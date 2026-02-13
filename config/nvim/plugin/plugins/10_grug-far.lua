-- Search and Replace
_G.Config.later(function()
    vim.pack.add({ { src = "https://github.com/MagicDuck/grug-far.nvim", version = vim.version.range("*") } })
    require("grug-far").setup({
        -- Disable folding.
        folding = { enabled = false },
        -- Don't numerate the result list.
        resultLocation = { showNumberLabel = false },
    })

    vim.keymap.set(
        { "n", "v" },
        "<leader>sr",
        function() require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } }) end,
        { desc = "Search and Replace current file" }
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>sR",
        function() require("grug-far").open({ transient = true }) end,
        { desc = "Search and Replace" }
    )
end)
