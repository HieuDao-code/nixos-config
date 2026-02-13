-- Install all LSP, DAP, Linter and Formatter
_G.Config.now_if_args(function()
    vim.pack.add({ { src = "https://github.com/mason-org/mason.nvim", version = vim.version.range("*") } })
    require("mason").setup()

    -- Ensure the servers and tools above are installed
    local ensure_installed = {
        -- DAP (Debug Adapter Protocol)
        "debugpy", -- Python

        -- Linter and Formatter
        "prettier", -- JSON, YAML, Markdown formatter
        "shellcheck", -- Shell linter
        "shfmt", -- Shell formatter
        "stylua", -- Lua formatter

        -- LSP (need config file in `lsp` folder)
        "bash-language-server", -- Bash, Zsh, Sh (uses shellcheck and shfmt)
        "copilot-language-server", -- GitHub Copilot
        "emmylua_ls", -- Lua
        "json-lsp", -- JSON
        "marksman", -- Markdown
        "ruff", -- Python (linter and formatter)
        "taplo", -- TOML (linter and formatter)
        "ty", -- Python
        "yaml-language-server", -- YAML
    }
    -- Install packages
    local mason_registry = require("mason-registry")
    mason_registry.refresh(function()
        for _, tool in ipairs(ensure_installed) do
            local mason_package = mason_registry.get_package(tool)
            if not mason_package:is_installed() then mason_package:install() end
        end
    end)

    vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Mason Menu" })
end)
