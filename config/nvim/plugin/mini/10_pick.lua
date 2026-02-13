-- Pick anything
_G.Config.later(function()
    local pick = require("mini.pick")
    local extra = require("mini.extra")
    pick.setup()

    -- Open LSP picker for the given scope
    ---@param scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol_live"
    ---@param autojump boolean? If there is only one result it will jump to it.
    function lsp_picker(scope, autojump)
        if not autojump then
            extra.pickers.lsp({ scope = scope })
            return
        end
        ---@param opts vim.lsp.LocationOpts.OnList
        local function on_list(opts)
            vim.fn.setqflist({}, " ", opts)
            if #opts.items == 1 then
                vim.cmd.cfirst()
            else
                extra.pickers.list({ scope = "quickfix" }, { source = { name = opts.title } })
            end
        end
        if scope == "references" then
            vim.lsp.buf.references(nil, { on_list = on_list })
            return
        end
        vim.lsp.buf[scope]({ on_list = on_list })
    end

    -- Keymaps
    vim.keymap.set("n", "<leader><leader>", function() require("fff_pick").run() end, { desc = "Smart Files" })
    vim.keymap.set("n", "<leader>ff", function() pick.builtin.files() end, { desc = "Files" })
    vim.keymap.set(
        "n",
        "<leader>fd",
        function()
            pick.builtin.cli({
                command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
            }, {
                source = {
                    name = "Dotfiles",
                    cwd = vim.fn.expand("~/.dotfiles"),
                },
            })
        end,
        { desc = "Dotfiles" }
    )
    vim.keymap.set("n", "<leader>/", function() pick.builtin.grep_live() end, { desc = "Grep" })
    vim.keymap.set("n", "<leader>fh", function() pick.builtin.help() end, { desc = "Help" })
    vim.keymap.set("n", "<leader>fb", function() pick.builtin.buffers() end, { desc = "Buffers" })

    -- mini.extra pickers
    vim.keymap.set("n", "<leader>fc", function() extra.pickers.commands() end, { desc = "Commands" })
    vim.keymap.set("n", "<leader>fg", function() extra.pickers.git_files() end, { desc = "Git Files" })
    vim.keymap.set("n", "<leader>fp", function() extra.pickers.hipatterns() end, { desc = "HiPatterns" })
    vim.keymap.set("n", "<leader>:", function() extra.pickers.history() end, { desc = "History" })
    vim.keymap.set("n", "<leader>fH", function() extra.pickers.hl_groups() end, { desc = "Highlights" })
    vim.keymap.set("n", "<leader>fk", function() extra.pickers.keymaps() end, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>cc", function() extra.pickers.colorschemes() end, { desc = "Colorschemes" })

    -- LSP
    vim.keymap.set("n", "gd", function() lsp_picker("definition", true) end, { desc = "Definition" })
    vim.keymap.set("n", "gD", function() lsp_picker("declaration", true) end, { desc = "Declaration" })
    vim.keymap.set("n", "grr", function() lsp_picker("references", true) end, { desc = "References" })
    vim.keymap.set("n", "gri", function() lsp_picker("implementation", true) end, { desc = "Implementation" })
    vim.keymap.set("n", "grt", function() lsp_picker("type_definition", true) end, { desc = "Type Definition" })
    vim.keymap.set("n", "gO", function() lsp_picker("document_symbol", true) end, { desc = "Document Symbols" })
    vim.keymap.set(
        "n",
        "<leader>fs",
        function() lsp_picker("workspace_symbol_live", false) end,
        { desc = "Workspace Symbol" }
    )
end)
