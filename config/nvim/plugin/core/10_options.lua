-- stylua: ignore start
-- General ====================================================================
vim.g.mapleader      = ' '                 -- Use `<Space>` as a leader key
vim.g.maplocalleader = '\\'                -- Use `\` as a local leader key

vim.o.mouse          = 'a'                 -- Enable mouse
vim.o.switchbuf      = 'usetab'            -- Use already opened buffers when switching
vim.o.undofile       = true                -- Enable persistent undo

-- Limit ShaDa file (for startup)
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- UI =========================================================================
vim.o.breakindent    = true                -- Indent wrapped lines to match line start
vim.o.cursorline     = true                -- Highlight the current line
vim.o.cursorlineopt  = 'screenline,number' -- Show cursor line per screen line
vim.o.cmdheight      = 0                   -- Use minimal command line height
vim.o.linebreak      = true                -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true                -- Show helpful text indicators
vim.o.number         = true                -- Show line numbers
vim.o.pumborder      = 'rounded'           -- Use border in popup menu
vim.o.relativenumber = true                -- Show relative line numbers
vim.o.ruler          = false               -- Don't show cursor position
vim.o.shortmess      = 'CFOSWaco'          -- Disable some built-in completion messages
vim.o.showmode       = false               -- Don't show mode in command line
vim.o.signcolumn     = 'yes'               -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true                -- Horizontal splits will be below
vim.o.splitkeep      = 'screen'            -- Reduce scroll during window split
vim.o.splitright     = true                -- Vertical splits will be to the right
vim.o.winborder      = 'rounded'           -- Use border in floating windows

-- Special UI symbols
vim.o.fillchars      = 'eob: '
vim.o.listchars      = 'extends:…,nbsp:␣,precedes:…,tab:> ,trail:·'

-- Folds
vim.o.foldcolumn     = '1'                 -- Show fold column
vim.o.foldlevelstart = 99                  -- Start with all folds open
vim.o.foldmethod     = 'indent'            -- Fold based on indent level
vim.o.foldnestmax    = 10                  -- Limit number of fold levels
vim.o.foldtext       = ''                  -- Use underlying text with its highlighting

-- Editing ====================================================================
vim.o.confirm        = true                -- Enable confirmation dialogs
vim.o.expandtab      = true                -- Convert tabs to spaces
vim.o.formatoptions  = 'rqnl1j'            -- Improve comment editing
vim.o.ignorecase     = true                -- Ignore case during search
vim.o.inccommand     = 'split'             -- Show the effects of a command incrementally
vim.o.scrolloff      = 999                 -- Keep cursor centered vertically
vim.o.shiftwidth     = 4                   -- Use this number of spaces for indentation
vim.o.smartcase      = true                -- Respect case if search pattern has upper case
vim.o.smartindent    = true                -- Make indenting smart
vim.o.softtabstop    = 4                   -- Number of spaces per Tab when editing
vim.o.tabstop        = 4                   -- Show tab as this number of spaces

-- Git diff
vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'indent-heuristic',
  'inline:char',
  'linematch:60',
  'algorithm:histogram',
  'vertical',
  'context:99',
}

-- Update times and timeouts.
vim.o.updatetime     = 300
vim.o.timeoutlen     = 500
vim.o.ttimeoutlen    = 10

-- stylua: ignore end
-- Diagnostics ================================================================
local diagnostic_icons = require("icons").diagnostics
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = "",
        format = function(diagnostics)
            -- Use shorter, nicer names for some sources:
            local special_sources = {
                ["EmmyLua"] = "lua",
            }

            -- Only show source and code, not the full message
            local message = diagnostic_icons[vim.diagnostic.severity[diagnostics.severity]]
            if diagnostics.source then
                message = string.format("%s %s", message, special_sources[diagnostics.source] or diagnostics.source)
            end
            if diagnostics.code then message = string.format("%s[%s]", message, diagnostics.code) end

            return message .. " "
        end,
    },
    signs = false, -- Disable signs in the gutter.
    float = {
        source = "if_many",
        -- Show severity icons as prefixes.
        prefix = function(diagnostics)
            local level = vim.diagnostic.severity[diagnostics.severity]
            local prefix = string.format(" %s ", diagnostic_icons[level])
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
        end,
        border = "rounded",
    },
    severity_sort = true,
})
