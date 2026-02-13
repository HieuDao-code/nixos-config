-- Highlight on yank
_G.Config.new_autocmd("TextYankPost", {
    desc = "Highlight on yank",
    callback = function() vim.hl.on_yank({ timeout = 250 }) end,
})

-- Yank with preserved cursor position and window state
local preserve_cursor = {}
preserve_cursor.state = {
    cursor_position = nil,
    win_state = nil,
}
-- Set cursor position and window state on yank
function preserve_cursor.on_yank()
    if nil ~= preserve_cursor.state.cursor_position then
        vim.fn.setpos(".", preserve_cursor.state.cursor_position)
        vim.fn.winrestview(preserve_cursor.state.win_state)
        preserve_cursor.state = {
            cursor_position = nil,
            win_state = nil,
        }
    end
end
-- Get cursor position and window state on yank
function preserve_cursor.yank(options)
    options = options or {}
    preserve_cursor.state = {
        cursor_position = vim.fn.getpos("."),
        win_state = vim.fn.winsaveview(),
    }
    vim.api.nvim_buf_attach(0, false, {
        on_lines = function()
            preserve_cursor.state = {
                cursor_position = nil,
                win_state = nil,
            }

            return true
        end,
    })
    return string.format("%sy", options.register and '"' .. options.register or "")
end
_G.Config.new_autocmd("TextYankPost", {
    desc = "Preserve cursor position on yank",
    pattern = "*",
    callback = function(_) preserve_cursor.on_yank() end,
})

vim.keymap.set({ "n", "x" }, "y", preserve_cursor.yank, { silent = true, expr = true })
