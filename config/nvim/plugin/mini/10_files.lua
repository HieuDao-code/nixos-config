-- Navigate and manipulate file system
_G.Config.later(function()
    require("mini.files").setup({
        mappings = {
            show_help = "?",
            go_in_plus = "<cr>",
            go_out_plus = "<tab>",
        },
        windows = { width_nofocus = 25 },
        options = { permanent_delete = false },
    })

    vim.keymap.set("n", "<leader>e", function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(bufname, ":p")
        -- If the buffer is a file, use its path; otherwise, use the current working directory
        if path and vim.uv.fs_stat(path) then
            MiniFiles.open(bufname, false)
        else
            -- Fresh explorer in current working directory
            MiniFiles.open(nil, false)
        end
    end, { desc = "File Explorer" })

    -- Toggle hidden files
    local show_dotfiles = true
    local filter_show = function(fs_entry) return true end
    local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
    local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
    end

    _G.Config.new_autocmd("User", {
        desc = "Toggle hidden files in MiniFiles",
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = args.data.buf_id, desc = "Toggle hidden files" })
        end,
    })

    -- LSP-integrated file renaming/moving
    _G.Config.new_autocmd("User", {
        desc = "Notify LSPs that a file was renamed",
        pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
        callback = function(args)
            local changes = {
                files = {
                    {
                        oldUri = vim.uri_from_fname(args.data.from),
                        newUri = vim.uri_from_fname(args.data.to),
                    },
                },
            }
            local will_rename_method, did_rename_method =
                vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
            local clients = vim.lsp.get_clients()
            for _, client in ipairs(clients) do
                if client:supports_method(will_rename_method) then
                    local res = client:request_sync(will_rename_method, changes, 1000, 0)
                    if res and res.result then vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding) end
                end
            end

            -- Notify clients that the rename has been completed
            for _, client in ipairs(clients) do
                if client:supports_method(did_rename_method) then client:notify(did_rename_method, changes) end
            end
        end,
    })
end)
