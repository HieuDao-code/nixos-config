-- Load built-in undotree plugin
_G.Config.later(function()
    vim.cmd.packadd("nvim.undotree")
    _G.Config.new_autocmd("FileType", {
        desc = "Disable line numbers in Undotree window",
        pattern = "nvim-undotree",
        callback = function()
            vim.wo.foldenable = false
            vim.wo.number = false
            vim.wo.relativenumber = false
        end,
    })

    vim.keymap.set("n", "<leader>u", function()
        local splitright = vim.o.splitright
        vim.o.splitright = false
        vim.cmd("Undotree")
        vim.o.splitright = splitright
    end, { desc = "Undotree" })
end)
