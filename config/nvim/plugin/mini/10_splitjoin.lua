-- Split and join arguments
_G.Config.later(function()
    local splitjoin = require("mini.splitjoin")

    splitjoin.setup({
        split = {
            hooks_post = {
                splitjoin.gen_hook.add_trailing_separator(),
            },
        },
        join = {
            hooks_post = {
                splitjoin.gen_hook.del_trailing_separator(),
                splitjoin.gen_hook.pad_brackets(),
            },
        },
    })
end)
