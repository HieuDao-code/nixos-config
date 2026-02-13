-- Session management (read, write, delete)
_G.Config.now(function()
    require("mini.sessions").setup()

    vim.keymap.set("n", "<leader>sw", function() MiniSessions.write("Session.vim") end, { desc = "Write" })
    vim.keymap.set("n", "<leader>ss", function() MiniSessions.select() end, { desc = "Select" })
    vim.keymap.set("n", "<leader>sd", function() MiniSessions.delete(nil, { force = true }) end, { desc = "Delete" })
end)
