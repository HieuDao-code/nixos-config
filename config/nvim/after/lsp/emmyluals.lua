---@type vim.lsp.Config
return {
    cmd = { "emmylua_ls" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".emmyrc.json",
        ".luacheckrc",
        ".git",
    },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                requirePattern = {
                    "?/lua/?.lua",
                    "?/lua/?/init.lua",
                },
            },
            workspace = {
                library = { vim.env.VIMRUNTIME },
            },
            diagnostics = {
                disable = { "undefined-global" },
            },
        },
    },
}
