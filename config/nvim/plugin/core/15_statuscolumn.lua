-- see: https://github.com/folke/snacks.nvim/blob/main/lua/snacks/statuscolumn.lua
-- # TODO : use mini.statuscolumn when available

---@class statuscolumn
---@overload fun(): string
local H = {}

--- Ensures the hl groups are always set, even after a colorscheme change.
local hl_groups = {} ---@type table<string, vim.api.keyset.highlight>
_G.Config.new_autocmd("ColorScheme", {
    desc = "Re-apply statuscolumn hl groups after colorscheme change",
    callback = function()
        for hl_group, hl in pairs(hl_groups) do
            vim.api.nvim_set_hl(0, hl_group, hl)
        end
    end,
})
local function set_hl(groups, opts)
    opts = opts or {}
    for hl_group, hl in pairs(groups) do
        hl_group = opts.prefix and opts.prefix .. hl_group or hl_group
        hl = type(hl) == "string" and { link = hl } or hl --[[@as vim.api.keyset.highlight]]
        hl.default = opts.default
        if opts.managed ~= false then hl_groups[hl_group] = hl end
        vim.api.nvim_set_hl(0, hl_group, hl)
    end
end

---@alias statuscolumn.Component "mark"|"sign"|"fold"|"git"
---@alias statuscolumn.Components statuscolumn.Component[]|fun(win:number,buf:number,lnum:number):statuscolumn.Component[]

---@class statuscolumn.Config
---@field left statuscolumn.Components
---@field right statuscolumn.Components
---@field enabled? boolean
local config = {
    left = { "mark", "sign" }, -- priority of signs on the left (high to low)
    right = { "fold", "git" }, -- priority of signs on the right (high to low)
    folds = {
        open = true, -- show open fold icons
        git_hl = true, -- use Git Signs hl for fold icons
    },
    git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
    },
    refresh = 50, -- refresh at most every 50ms
}

---@alias statuscolumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias statuscolumn.Sign {name:string, text:string, texthl:string, priority:number, type:statuscolumn.Sign.type}

-- Cache for signs per buffer and line
---@type table<number,table<number,statuscolumn.Sign[]>>
local sign_cache = {}
local cache = {} ---@type table<string,string>
local icon_cache = {} ---@type table<string,string>

---@private
---@param name string
function H.is_git_sign(name)
    for _, pattern in ipairs(config.git.patterns) do
        if name:find(pattern) then return true end
    end
end

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@private
---@return table<number, statuscolumn.Sign[]>
---@param buf number
function H.buf_signs(buf)
    -- Get regular signs
    ---@type table<number, statuscolumn.Sign[]>
    local signs = {}

    -- Get extmark signs
    local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
    for _, extmark in pairs(extmarks) do
        local lnum = extmark[2] + 1
        signs[lnum] = signs[lnum] or {}
        local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
        table.insert(signs[lnum], {
            name = name,
            type = H.is_git_sign(name) and "git" or "sign",
            text = extmark[4].sign_text,
            texthl = extmark[4].sign_hl_group,
            priority = extmark[4].priority,
        })
    end

    -- Add marks
    local marks = vim.fn.getmarklist(buf)
    vim.list_extend(marks, vim.fn.getmarklist())
    for _, mark in ipairs(marks) do
        if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
            local lnum = mark.pos[2]
            signs[lnum] = signs[lnum] or {}
            table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "MyStatusColumnMark", type = "mark" })
        end
    end

    return signs
end

-- Returns a list of regular and extmark signs sorted by priority (high to low)
---@private
---@param win number
---@param buf number
---@param lnum number
---@return statuscolumn.Sign[]
function H.line_signs(win, buf, lnum)
    local buf_signs = sign_cache[buf]
    if not buf_signs then
        buf_signs = H.buf_signs(buf)
        sign_cache[buf] = buf_signs
    end
    local signs = buf_signs[lnum] or {}

    -- Get fold signs
    vim.api.nvim_win_call(win, function()
        if vim.fn.foldclosed(lnum) >= 0 then
            signs[#signs + 1] = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
        elseif config.folds.open and vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
            signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
        end
    end)

    -- Sort by priority
    table.sort(signs, function(a, b) return (a.priority or 0) > (b.priority or 0) end)
    return signs
end

---@private
---@param sign? statuscolumn.Sign
function H.icon(sign)
    if not sign then return "  " end
    local key = (sign.text or "") .. (sign.texthl or "")
    if icon_cache[key] then return icon_cache[key] end
    local text = vim.fn.strcharpart(sign.text or "", 0, 2) ---@type string
    text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
    icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
    return icon_cache[key]
end

---@return string
function H._get()
    local win = vim.g.statusline_winid
    local nu = vim.wo[win].number
    local rnu = vim.wo[win].relativenumber
    local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
    local components = { "", "", "" } -- left, middle, right
    if not (show_signs or nu or rnu) then return "" end

    if (nu or rnu) and vim.v.virtnum == 0 then
        local num ---@type number
        if rnu and nu and vim.v.relnum == 0 then
            num = vim.v.lnum
        elseif rnu then
            num = vim.v.relnum
        else
            num = vim.v.lnum
        end
        components[2] = "%=" .. num .. " "
    end

    if show_signs then
        local buf = vim.api.nvim_win_get_buf(win)
        local is_file = vim.bo[buf].buftype == ""
        local signs = H.line_signs(win, buf, vim.v.lnum)

        if #signs > 0 then
            local signs_by_type = {} ---@type table<statuscolumn.Sign.type,statuscolumn.Sign>
            for _, s in ipairs(signs) do
                signs_by_type[s.type] = signs_by_type[s.type] or s
            end

            ---@param types statuscolumn.Sign.type[]
            local function find(types)
                for _, t in ipairs(types) do
                    if signs_by_type[t] then return signs_by_type[t] end
                end
            end

            local left_c = type(config.left) == "function" and config.left(win, buf, vim.v.lnum) or config.left --[[@as statuscolumn.Component[] ]]
            local right_c = type(config.right) == "function" and config.right(win, buf, vim.v.lnum) or config.right --[[@as statuscolumn.Component[] ]]
            local left, right = find(left_c), find(right_c)

            if config.folds.git_hl then
                local git = signs_by_type.git
                if git and left and left.type == "fold" then left.texthl = git.texthl end
                if git and right and right.type == "fold" then right.texthl = git.texthl end
            end
            components[1] = left and H.icon(left) or "  " -- left
            components[3] = is_file and (right and H.icon(right) or "  ") or "" -- right
        else
            components[1] = "  "
            components[3] = is_file and "  " or ""
        end
    end

    local ret = table.concat(components, "")
    return ret
end

function _G.Config.statuscolumn()
    local win = vim.g.statusline_winid
    local buf = vim.api.nvim_win_get_buf(win)
    local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)
    if cache[key] then return cache[key] end
    local ok, ret = pcall(H._get)
    if ok then
        cache[key] = ret
        return ret
    end
    return ""
end

-- Setup
set_hl({ Mark = "DiagnosticHint" }, { prefix = "MyStatusColumn", default = true })
local timer = assert(vim.uv.new_timer())
timer:start(config.refresh, config.refresh, function()
    sign_cache = {}
    cache = {}
end)

vim.o.statuscolumn = [[%!v:lua.Config.statuscolumn()]]
