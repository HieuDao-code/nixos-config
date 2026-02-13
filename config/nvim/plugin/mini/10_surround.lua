-- Add/delete/replace surroundings (brackets, quotes, etc.)
_G.Config.later(
    function()
        require("mini.surround").setup({
            mappings = {
                add = "ys",
                delete = "ds",
                find = "",
                find_left = "",
                highlight = "",
                replace = "cs",
                update_n_lines = "",
            },
            search_method = "cover_or_next",
        })
    end
)
