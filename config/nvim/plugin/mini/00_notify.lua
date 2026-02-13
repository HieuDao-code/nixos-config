-- Show notifications
_G.Config.now(function()
    require("mini.notify").setup({})
    _G.Config.new_autocmd("FileType", {
        desc = "Better close notify history with <q>",
        pattern = "mininotify-history",
        callback = function(args) vim.keymap.set("n", "q", "<CMD>bd<CR>", { buffer = args.buf }) end,
    })

    vim.keymap.set("n", "<leader>n", function() MiniNotify.show_history() end, { desc = "Notification history" })
end)
