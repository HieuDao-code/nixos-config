-- Extend and create a/i textobjects
_G.Config.later(function()
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 300,
        custom_textobjects = {
            -- Function definition (needs treesitter queries with these captures)
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            -- Whole buffer.
            g = function()
                local from = { line = 1, col = 1 }
                local to = {
                    line = vim.fn.line("$"),
                    col = math.max(vim.fn.getline("$"):len(), 1),
                }
                return { from = from, to = to }
            end,
        },
        -- Disable error feedback.
        silent = true,
    })
end)
