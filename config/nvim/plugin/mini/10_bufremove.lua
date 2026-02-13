-- Buffer removing (unshow, delete, wipeout), which saves window layout
_G.Config.later(function()
    require("mini.bufremove").setup()

    -- Check if windows are fixed to buffers
    local function can_remove_buf(buf)
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            if vim.api.nvim_get_option_value("winfixbuf", { win = win }) then return false end
        end
        return true
    end

    vim.keymap.set("n", "<leader>bd", function()
        local buf = vim.api.nvim_get_current_buf()
        if can_remove_buf(buf) then MiniBufremove.delete(buf, false) end
    end, { desc = "Delete current buffers" })

    vim.keymap.set("n", "<leader>bo", function()
        local current_buf = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= current_buf and can_remove_buf(buf) then MiniBufremove.delete(buf, false) end
        end
    end, { desc = "Delete other buffers" })
end)
