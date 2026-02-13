-- Code with LLM
_G.Config.later(function()
    vim.pack.add({
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/olimorris/codecompanion.nvim", version = vim.version.range("*") },
    })
    require("codecompanion").setup({
        interactions = {
            inline = {
                keymaps = {
                    accept_change = {
                        modes = { n = "<leader>ay" },
                        description = "Accept the suggested change",
                    },
                    reject_change = {
                        modes = { n = "<leader>an" },
                        description = "Reject the suggested change",
                    },
                },
            },
            chat = {
                keymaps = {
                    clear = {
                        modes = { n = "gX" },
                        description = "Clear chat",
                    },
                },
            },
        },
    })

    -- Use MiniNotify to track start / stop of requests
    local ids = {} -- CodeCompanion request ID --> MiniNotify notification ID

    local function format_request_status(event)
        local name = event.data.adapter.formatted_name or event.data.adapter.name
        local msg = name .. " " .. event.data.interaction .. " request..."
        local level, hl_group = "INFO", "DiagnosticInfo"
        if event.data.status then
            msg = msg .. event.data.status
            if event.data.status ~= "success" then
                level, hl_group = "ERROR", "DiagnosticError"
            end
        end
        return msg, level, hl_group
    end

    _G.Config.new_autocmd({ "User" }, {
        desc = "Notify when CodeCompanion request starts",
        pattern = "CodeCompanionRequestStarted",
        callback = function(event)
            local msg, level, hl_group = format_request_status(event)
            ids[event.data.id] = MiniNotify.add(msg, level, hl_group)
        end,
    })

    _G.Config.new_autocmd({ "User" }, {
        desc = "Notify when CodeCompanion request finishes",
        pattern = "CodeCompanionRequestFinished",
        callback = function(event)
            local msg, level, hl_group = format_request_status(event)
            local mini_id = ids[event.data.id]
            if mini_id then
                ids[event.data.id] = nil
                MiniNotify.update(mini_id, { msg = msg, level = level, hl_group = hl_group })
            else
                mini_id = MiniNotify.add(msg, level, hl_group)
            end
            vim.defer_fn(function() MiniNotify.remove(mini_id) end, 3000)
        end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>ap", "<CMD>CodeCompanionActions<CR>", { desc = "CodeCompanion actions" })
    vim.keymap.set("n", "<leader>at", "<CMD>CodeCompanionChat Toggle<CR>", { desc = "Toggle CodeCompanion chat" })
    vim.keymap.set("x", "<leader>aa", "<CMD>CodeCompanionChat Add<CR>", { desc = "Add to CodeCompanion chat" })
end)
