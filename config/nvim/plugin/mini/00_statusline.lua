-- Minimal and fast statusline module with opinionated default look
local H = {}
_G.Config.now(function()
    local icons = require("icons")

    require("mini.statusline").setup({
        -- Content of statusline as functions which return statusline string. See
        -- `:h statusline` and code of default contents (used instead of `nil`).
        content = {
            -- Content for active window
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                mode = string.upper(mode)

                -- Dynamically set fg of Devinfo and Fileinfo to mode_hl bg
                local mode_hl_def = vim.api.nvim_get_hl(0, { name = mode_hl, link = false })
                local fg = mode_hl_def and mode_hl_def.bg and string.format("#%06x", mode_hl_def.bg) or nil
                if fg then
                    local devinfo_bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineDevinfo", link = false }).bg
                    local fileinfo_bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineFileinfo", link = false }).bg
                    vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = fg, bg = devinfo_bg })
                    vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = fg, bg = fileinfo_bg })
                end

                local git = MiniStatusline.section_git({ trunc_width = 40, icon = icons.misc.git })
                local diff = MiniStatusline.section_diff({ trunc_width = 75, icon = icons.misc.vertical_bar .. " " })
                local diagnostics = MiniStatusline.section_diagnostics({
                    trunc_width = 75,
                    icon = icons.misc.vertical_bar,
                    signs = {
                        ERROR = icons.diagnostics.ERROR .. " ",
                        WARN = icons.diagnostics.WARN .. " ",
                        INFO = icons.diagnostics.INFO .. " ",
                        HINT = icons.diagnostics.HINT .. " ",
                    },
                })
                local lsp = MiniStatusline.section_lsp({ trunc_width = 75, icon = icons.misc.search })
                local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 1000 })
                local location = MiniStatusline.section_location({ trunc_width = 75 })
                local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
                local python_venv = (vim.bo.filetype == "python")
                        and (MiniStatusline.is_truncated(120) and "" or H.get_venv())
                    or ""

                return MiniStatusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
                    "%<", -- Mark general truncate point
                    { hl = "MiniStatuslineFilename", strings = { filename } },
                    "%=", -- End left alignment
                    { hl = "MiniStatuslineFileinfo", strings = { lsp, fileinfo, python_venv } },
                    { hl = mode_hl, strings = { search, location } },
                })
            end,
            -- Content for inactive window(s)
            inactive = nil,
        },
        -- Whether to use icons by default
        use_icons = true,
    })
end)

-- Get python virtual environment info
H.venv_cache = { path = nil, info = nil }
H.get_venv = function()
    local venv = vim.env.VIRTUAL_ENV
    -- Return cached result if venv hasn't changed
    if H.venv_cache.path == venv and H.venv_cache.info then return H.venv_cache.info end

    local result
    if venv then
        local venv_name = vim.fn.fnamemodify(venv, ":h:t")
        local version

        -- Try to read version from pyvenv.cfg (faster, no shell)
        local cfg = venv .. "/pyvenv.cfg"
        if vim.fn.filereadable(cfg) == 1 then
            for _, line in ipairs(vim.fn.readfile(cfg)) do
                local v = line:match("version%s*=%s*(%d+%.%d+%.%d+)")
                if v then
                    version = v
                    break
                end
            end
        end

        -- Fallback: run python --version
        if not version then
            local python = venv .. "/bin/python"
            if vim.fn.executable(python) == 1 then
                local out = vim.fn.system(python .. " --version")
                version = out:match("(%d+%.%d+%.%d+)")
            end
        end

        if version then
            result = version .. " " .. venv_name
        else
            result = "<no venv activated>"
        end
    else
        result = "<no venv activated>"
    end

    H.venv_cache = { path = venv, info = result }
    return result
end
