-- Show next key clues
_G.Config.later(function()
    local miniclue = require("mini.clue")
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = { "n", "x" }, keys = "<Leader>" },

            -- `[` and `]` keys
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },

            -- Built-in completion
            { mode = "i", keys = "<C-x>" },

            -- `g` key
            { mode = { "n", "x" }, keys = "g" },

            -- Marks
            { mode = { "n", "x" }, keys = "'" },
            { mode = { "n", "x" }, keys = "`" },

            -- Registers
            { mode = { "n", "x" }, keys = '"' },
            { mode = { "i", "c" }, keys = "<C-r>" },

            -- Window commands
            { mode = "n", keys = "<C-w>" },

            -- `z` key
            { mode = { "n", "x" }, keys = "z" },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.square_brackets(),
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers({ show_contents = true }),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),

            -- Add custom clues for <Leader> mappings
            { mode = "n", keys = "<Leader>a", desc = "+AI" },
            { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
            { mode = "n", keys = "<Leader>c", desc = "+Change" },
            { mode = "n", keys = "<Leader>d", desc = "+Debug" },
            { mode = "n", keys = "<Leader>f", desc = "+Find" },
            { mode = "n", keys = "<Leader>g", desc = "+Git" },
            { mode = "n", keys = "<Leader>s", desc = "+Search/Sessions" },
            { mode = "n", keys = "<Leader>t", desc = "+Test" },
            { mode = "n", keys = "<Leader>x", desc = "+Trouble" },
        },
    })
end)
