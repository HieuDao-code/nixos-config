-- LSP configuration for Neovim
_G.Config.new_autocmd("LspAttach", {
    desc = "LSP settings",
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then return end

        vim.keymap.set("n", "grn", vim.lsp.buf.rename, { noremap = true, buffer = bufnr, desc = "Rename" })

        -- Show code action lightbulb if supported by the server
        if client:supports_method("textDocument/codeAction") then
            require("lightbulb").attach_lightbulb(bufnr, client)
            vim.keymap.set(
                { "n", "x" },
                "gra",
                vim.lsp.buf.code_action,
                { noremap = true, buffer = bufnr, desc = "Code Action" }
            )
        end

        -- Show signature help
        if client:supports_method("textDocument/signatureHelp") then
            vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, { noremap = true, buffer = bufnr })
        end

        -- Inline Completion (e.g. Copilot)
        if client:supports_method("textDocument/inlineCompletion") then
            vim.lsp.inline_completion.enable(true)

            vim.keymap.set("i", "<TAB>", function()
                if vim.fn.col(".") == 1 or not vim.lsp.inline_completion.get() then return "<TAB>" end
            end, {
                expr = true,
                replace_keycodes = true,
                desc = "Get the current inline completion",
            })
        end

        -- Show references on CursorHold
        if client:supports_method("textDocument/documentHighlight") then
            _G.Config.new_autocmd({ "CursorHold", "InsertLeave" }, {
                desc = "Highlight references under the cursor",
                buffer = bufnr,
                callback = function()
                    -- Check if still supported before calling
                    local clients = vim.lsp.get_clients({ bufnr = bufnr })
                    for _, c in ipairs(clients) do
                        if c:supports_method("textDocument/documentHighlight") then
                            vim.lsp.buf.document_highlight()
                            return
                        end
                    end
                end,
            })
            _G.Config.new_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
                desc = "Clear highlight references",
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Toggle inlay hints
        if client:supports_method("textDocument/inlayHint") then
            vim.keymap.set(
                "n",
                "<leader>ch",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                end,
                { noremap = true, buffer = bufnr, desc = "Toggle inlay hints" }
            )
        end

        -- Disable hover in favor of ty
        if client and client.name == "ruff" then client.server_capabilities.hoverProvider = false end
    end,
})

-- Set up LSP servers
local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
    :map(function(file) return vim.fn.fnamemodify(file, ":t:r") end)
    :totable()
vim.lsp.enable(servers)
