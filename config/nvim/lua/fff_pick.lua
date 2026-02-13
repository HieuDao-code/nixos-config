-- mini.pick frontend for fff.nvim

local M = {}
M.state = {}

M.find = function(query)
    local file_picker = require("fff.file_picker")

    query = query or ""
    local fff_result = file_picker.search_files(query, M.state.current_file_cache, 100, 4, 0)
    local items = {}
    for _, fff_item in ipairs(fff_result) do
        local item = {
            text = fff_item.relative_path,
            path = fff_item.path,
        }
        table.insert(items, item)
    end

    return items
end

M.show = function(buf_id, items)
    local ns_id = vim.api.nvim_create_namespace("MiniPick FFFiles Picker")
    local icon_data = {}

    -- Show items
    local items_to_show = {}
    for i, item in ipairs(items) do
        local icon, hl, _ = MiniIcons.get("file", item.text)
        icon_data[i] = { icon = icon, hl = hl }

        items_to_show[i] = string.format("%s %s", icon, item.text)
    end
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, items_to_show)

    vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)

    local icon_extmark_opts = { hl_mode = "combine", priority = 200 }
    for i, _ in ipairs(items) do
        -- Highlight Icons
        icon_extmark_opts.hl_group = icon_data[i].hl
        icon_extmark_opts.end_row, icon_extmark_opts.end_col = i - 1, 1
        vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, icon_extmark_opts)
    end
end

M.run = function()
    -- Setup fff.nvim
    local file_picker = require("fff.file_picker")
    if not file_picker.is_initialized() then
        local setup_success = file_picker.setup()
        if not setup_success then
            vim.notify("Could not setup fff.nvim", vim.log.levels.ERROR)
            return
        end
    end

    -- Cache current file to deprioritize in fff.nvim
    if not M.state.current_file_cache then
        local current_buf = vim.api.nvim_get_current_buf()
        if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
            local current_file = vim.api.nvim_buf_get_name(current_buf)
            if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
                local relative_path = vim.fs.relpath(vim.uv.cwd(), current_file)
                M.state.current_file_cache = relative_path
            else
                M.state.current_file_cache = nil
            end
        end
    end

    -- Start picker
    MiniPick.start({
        source = {
            name = "Smart File Finder",
            items = M.find,
            match = function(_, _, query)
                local items = M.find(table.concat(query))
                MiniPick.set_picker_items(items, { do_match = false })
            end,
            show = M.show,
        },
    })

    M.state.current_file_cache = nil -- Reset cache
end

return M
