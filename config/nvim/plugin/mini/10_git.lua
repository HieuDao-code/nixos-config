-- Git integration
_G.Config.later(function()
    require("mini.git").setup()

    --- For statusline integration ---
    _G.Config.new_autocmd("User", {
        desc = "Update MiniGit summary string for statusline",
        pattern = "MiniGitUpdated",
        callback = function(data)
            -- Use only HEAD name as summary string
            -- Utilize buffer-local table summary
            local summary = vim.b[data.buf].minigit_summary
            vim.b[data.buf].minigit_summary_string = summary.head_name or ""
        end,
    })

    --- Git blame ---
    -- Highlight groups
    _G.Config.new_autocmd("ColorScheme", {
        desc = "Set GitBlame highlight groups",
        callback = function()
            vim.api.nvim_set_hl(0, "GitBlameHashRoot", { link = "Tag" })
            vim.api.nvim_set_hl(0, "GitBlameHash", { link = "Identifier" })
            vim.api.nvim_set_hl(0, "GitBlameAuthor", { link = "String" })
            vim.api.nvim_set_hl(0, "GitBlameDate", { link = "Comment" })
        end,
    })

    -- Setup when opening blame window
    _G.Config.new_autocmd("User", {
        desc = "Setup Git blame window",
        pattern = "MiniGitCommandSplit",
        callback = function(au_data)
            if au_data.data.git_subcommand ~= "blame" then return end
            local win_src = au_data.data.win_source
            local buf = au_data.buf
            local win = au_data.data.win_stdout
            -- Opts
            vim.bo[buf].modifiable = false
            vim.wo[win].wrap = false
            vim.wo[win].cursorline = true
            -- View
            vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
            vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
            vim.wo[win].scrollbind, vim.wo[win_src].scrollbind = true, true
            vim.wo[win].cursorbind, vim.wo[win_src].cursorbind = true, true
            -- Vert width
            if au_data.data.cmd_input.mods == "vertical" then
                local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
                local width = vim.iter(lines):fold(-1, function(acc, ln)
                    local stat = string.match(ln, "^(.*%s+%d+%))%s+")
                    return math.max(acc, vim.fn.strwidth(stat))
                end)
                width = width + vim.fn.getwininfo(win)[1].textoff
                vim.api.nvim_win_set_width(win, width)
            end
            -- Highlight
            vim.fn.matchadd("GitBlameHashRoot", [[^^\w\+]])
            vim.fn.matchadd("GitBlameHash", [[^\w\+]])
            local leftmost = [[^.\{-}\zs]]
            vim.fn.matchadd("GitBlameAuthor", leftmost .. [[(\zs.\{-} \ze\d\{4}-]])
            vim.fn.matchadd("GitBlameDate", leftmost .. [[[0-9-]\{10} [0-9:]\{8} +\d\+]])
        end,
    })

    vim.keymap.set("n", "<leader>gb", function()
        vim.o.splitright = false
        vim.cmd("vert Git blame -- %")
        vim.o.splitright = true
    end, { desc = "Blame" })
end)
