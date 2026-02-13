-- Finally a Fast Fuzzy File Finder for neovim
_G.Config.now(function()
    -- require("fff.download").download_or_build_binary()
    _G.Config.on_packchanged(
        "fff.nvim",
        { "install", "update" },
        function() require("fff.download").download_or_build_binary() end,
        "Download or build fff.nvim binary"
    )
    vim.pack.add({
        {
            src = "https://github.com/dmtrKovalenko/fff.nvim",
            -- TODO : Pin version when stable release is available
            -- version = vim.version.range("*"),
        },
    })
end)
