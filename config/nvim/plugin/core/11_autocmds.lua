-- Better quit
_G.Config.new_autocmd("FileType", {
    desc = "Better close with <q>",
    pattern = {
        "argseditor",
        "git",
        "grug-far",
        "help",
        "man",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "nvim-pack",
        "nvim-undotree",
        "qf",
        "scratch",
    },
    callback = function(args) vim.keymap.set("n", "q", "<CMD>quit<CR>", { buffer = args.buf }) end,
})

-- Automatically toggle relative line numbers
_G.Config.new_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
    desc = "Toggle relative line numbers on",
    callback = function()
        if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, "i") then vim.wo.relativenumber = true end
    end,
})
_G.Config.new_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    desc = "Toggle relative line numbers off",
    callback = function(args)
        if vim.wo.nu then vim.wo.relativenumber = false end

        -- Redraw here to avoid having to first write something for the line numbers to update.
        if args.event == "CmdlineEnter" then
            if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then vim.cmd.redraw() end
        end
    end,
})

-- Go to last location when opening a buffer
_G.Config.new_autocmd("BufReadPost", {
    desc = "Go to the last location when opening a buffer",
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
    end,
})

-- Redraw screen when marks are changed via `m` commands
vim.on_key(function(_, typed)
    if typed:sub(1, 1) ~= "m" then return end
    local mark = typed:sub(2)
    vim.schedule(function()
        if mark:match("[A-Z]") then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
            end
        else
            vim.api.nvim__redraw({ range = { 0, -1 } })
        end
    end)
end, vim.api.nvim_create_namespace("marks"))

-- Open help in a vertical split
_G.Config.new_autocmd("BufEnter", {
    desc = "Open help in vertical split",
    callback = function()
        if vim.bo.buftype == "help" then vim.cmd("wincmd L") end
    end,
})

-- Auto resize splits when the terminal's window is resized
_G.Config.new_autocmd("VimResized", {
    desc = "Auto resize splits when the terminal window is resized",
    command = "wincmd =",
})

-- Show cursorline only in active window
_G.Config.new_autocmd({ "WinEnter", "BufEnter" }, {
    desc = "Show cursorline in active window",
    callback = function() vim.opt_local.cursorline = true end,
})
_G.Config.new_autocmd({ "WinLeave", "BufLeave" }, {
    desc = "Hide cursorline in inactive window",
    callback = function() vim.opt_local.cursorline = false end,
})
