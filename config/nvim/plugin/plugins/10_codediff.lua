-- VSCode-style side-by-side diff rendering with two-tier highlighting
_G.Config.later(function()
    vim.pack.add({
        { src = "https://github.com/MunifTanjim/nui.nvim" },
        { src = "https://github.com/esmuellert/codediff.nvim", version = vim.version.range("*") },
    })
    require("codediff").setup({
        explorer = {
            view_mode = "tree",
        },
        keymaps = {
            view = {
                next_file = "<TAB>",
                prev_file = "<S-TAB>",
            },
        },
    })

    vim.keymap.set("n", "<leader>gf", "<CMD>CodeDiff history %<CR>", { desc = "Current file history" })
    vim.keymap.set("n", "<leader>gF", "<CMD>CodeDiff history<CR>", { desc = "File history" })
    vim.keymap.set("n", "<leader>gd", "<CMD>CodeDiff<CR>", { desc = "Open codediff" })
end)
