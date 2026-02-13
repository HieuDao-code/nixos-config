-- Render markdown in Neovim
Config.now_if_args(function()
    vim.pack.add({
        { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim", version = vim.version.range("*") },
    })
    local render_markdown = require("render-markdown")
    render_markdown.setup({
        file_types = { "markdown", "codecompanion" },
        completions = {
            lsp = {
                enabled = true,
            },
        },
    })

    vim.keymap.set("n", "<leader>m", function() render_markdown.toggle() end, { desc = "Toggle Markdown rendering" })
end)
