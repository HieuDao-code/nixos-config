-- File navigation using argument list
vim.keymap.set("n", "<leader>h", function()
    vim.cmd("argadd %:~:.")
    vim.cmd("argdedupe")
end, { desc = "Add current file to args list" })

-- Directly go to first 5 arguments
for i = 1, 5 do
    vim.keymap.set(
        "n",
        "<leader>" .. i,
        function() vim.cmd("silent! " .. i .. "argument") end,
        { desc = "Go to argument " .. i }
    )
end

-- Navigate argument list circularly
local function nav_arglist(count)
    local arglen = vim.fn.argc()
    if arglen == 0 then return end
    local idx = vim.fn.argidx()
    local next = (idx + count) % arglen
    if next < 0 then next = next + arglen end
    vim.cmd((math.floor(next + 1)) .. "argument")
    vim.cmd("args")
end

vim.keymap.set("n", "[a", function() nav_arglist(-(vim.v.count1 or 1)) end, { desc = ":previous" })
vim.keymap.set("n", "]a", function() nav_arglist(vim.v.count1 or 1) end, { desc = ":next" })

-- Edit arglist in floating window
local argseditor_win = nil
local argseditor_buf = nil

vim.keymap.set("n", "<C-e>", function()
    -- If window exists, close it
    if argseditor_win and vim.api.nvim_win_is_valid(argseditor_win) then
        vim.api.nvim_win_close(argseditor_win, true)
        return
    end

    -- Set dimensions
    local abs_height = 15
    local rel_width = 0.75

    -- Create buf
    argseditor_buf = vim.api.nvim_create_buf(false, true)
    local filetype = "argseditor"
    vim.api.nvim_set_option_value("filetype", filetype, { buf = argseditor_buf })

    -- Create centered floating window
    local cur_win = vim.api.nvim_get_current_win()
    local win_height = vim.api.nvim_win_get_height(cur_win)
    local win_width = vim.api.nvim_win_get_width(cur_win)
    argseditor_win = vim.api.nvim_open_win(argseditor_buf, true, {
        relative = "win",
        win = cur_win,
        height = abs_height,
        width = math.ceil(win_width * rel_width),
        row = math.ceil(win_height / 2 - abs_height / 2),
        col = math.ceil(win_width / 2 - (win_width * rel_width) / 2),
        title = filetype,
    })
    vim.wo.relativenumber = false

    -- Put current arglist
    local arglist = vim.fn.argv(-1)
    local to_read = type(arglist) == "table" and arglist or { arglist }
    vim.api.nvim_buf_set_lines(argseditor_buf, 0, -1, false, to_read)

    -- Go to file under cursor
    vim.keymap.set("n", "<CR>", function()
        local f = vim.fn.getline(".")
        vim.api.nvim_buf_delete(argseditor_buf, { force = true })
        vim.cmd.e(f)
    end, { desc = "Go to file under cursor" })

    -- Auto-update arglist when window is closed
    _G.Config.new_autocmd("WinClosed", {
        desc = "Close arglist editor and update arglist",
        buffer = argseditor_buf,
        once = true,
        callback = function()
            local to_write = vim.api.nvim_buf_get_lines(argseditor_buf, 0, -1, true)
            local args = {}
            for _, line in ipairs(to_write) do
                local trimmed = vim.trim(line)
                if trimmed ~= "" then table.insert(args, trimmed) end
            end
            vim.cmd("%argd")
            if #args > 0 then vim.cmd.arga(table.concat(args, " ")) end
        end,
    })
end, { desc = "Toggle arglist editor" })
