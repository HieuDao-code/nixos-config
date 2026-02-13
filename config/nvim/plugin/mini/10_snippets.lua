-- Manage and expand snippets
_G.Config.later(function()
    local snippets = require("mini.snippets")
    snippets.setup({
        snippets = {
            -- Load snippets based on current language by reading files from
            -- "snippets/" subdirectories from 'runtimepath' directories.
            snippets.gen_loader.from_lang(),
        },
    })
end)
