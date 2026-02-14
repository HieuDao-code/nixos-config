-- Highlight, edit, and navigate code
_G.Config.now_if_args(function()
    _G.Config.on_packchanged(
        "nvim-treesitter",
        { "update" },
        function() vim.cmd("TSUpdate") end,
        "Update tree-sitter parsers"
    )
    vim.pack.add({
        { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    })

    -- Ensure parsers are installed
    local ensure_languages = {
        "bash",
        "c",
        "fish",
        "gitcommit",
        "html",
        "ini",
        "json",
        "just",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        "zsh",
    }
    local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
    local to_install = vim.tbl_filter(isnt_installed, ensure_languages)
    if #to_install > 0 then require("nvim-treesitter").install(to_install) end

    -- Ensure enabled
    local function treesitter_start(event)
        local bufnr = event.buf
        vim.treesitter.start(bufnr)
        -- Use regex based syntax-highlighting as fallback as some plugins might need it
        vim.bo[bufnr].syntax = "ON"
        -- Use treesitter for folds if file is not too big
        if vim.bo[bufnr].modifiable and vim.bo[bufnr].filetype ~= "bigfile" then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.cmd.normal("zx")
        end
        -- Use treesitter for indentation
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    local filetypes = vim.iter(ensure_languages):map(vim.treesitter.language.get_filetypes):flatten():totable()
    _G.Config.new_autocmd("FileType", {
        desc = "Ensure enabled tree-sitter",
        pattern = filetypes,
        callback = treesitter_start,
    })

    -- Display context when current block is off-screen
    require("treesitter-context").setup({
        multiline_threshold = 1,
    })
end)
