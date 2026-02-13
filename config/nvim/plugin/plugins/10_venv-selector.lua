--  Allows selection of python virtual environment from within neovim
_G.Config.later(function()
    vim.pack.add({
        { src = "https://github.com/mfussenegger/nvim-dap" },
        { src = "https://github.com/mfussenegger/nvim-dap-python" },
        { src = "https://github.com/linux-cultist/venv-selector.nvim" },
    })

    -- Find git root
    local git_root = vim.trim(
        vim.fn.system("git -C " .. vim.fn.fnameescape(vim.fn.getcwd()) .. " rev-parse --show-toplevel")
    ) or ""
    require("venv-selector").setup({
        options = {
            enable_default_searches = false,
            on_telescope_result_callback = function(filename)
                -- Remove /bin/python and remove git root from the path
                local path = filename:gsub("/bin/python$", "")
                if git_root and git_root ~= "" then
                    local idx = path:find(git_root, 1, true)
                    if idx then
                        path = path:sub(idx + #git_root)
                        if path:sub(1, 1) == "/" then path = path:sub(2) end
                    end
                end
                return path
            end,
            picker_columns = { "marker", "search_result" },
        },
        search = {
            cwd_search = {
                command = "$FD '/bin/python$' $CWD --full-path --color never -HI -a -L -E /proc -E .git/ -E site-packages/ -E .tox/",
            },
            workspace_search = {
                command = "$FD '/bin/python$' $WORKSPACE_PATH --full-path --color never -HI -a -L -E /proc -E .git/ -E site-packages/ -E .tox/",
            },
        },
    })

    vim.keymap.set("n", "<leader>v", "<CMD>VenvSelect<CR>", { desc = "Venv select (Python)" })
end)
