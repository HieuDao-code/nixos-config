-- Autoformatter
_G.Config.later(function()
    vim.pack.add({ { src = "https://github.com/stevearc/conform.nvim", version = vim.version.range("*") } })
    require("conform").setup({
        notify_on_error = false,
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            -- Conform can also run multiple formatters sequentially
            bash = { "shfmt" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            nix = { "nixfmt" },
            python = {
                -- To fix auto-fixable lint errors.
                "ruff_fix",
                -- To run the Ruff formatter.
                "ruff_format",
                -- To organize the imports.
                "ruff_organize_imports",
            },
            sh = { "shfmt" },
            toml = { "taplo" },
            yaml = { "prettier" },
            zsh = { "shfmt" },
        },
    })
end)
