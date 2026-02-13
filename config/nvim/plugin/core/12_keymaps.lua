-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR>")

-- Easier way to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Indent while remaining in visual mode.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Make j/k visual down and up instead of whole lines. This makes word wrapping a lot more pleasent.
vim.keymap.set({ "n", "x" }, "j", "gj", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "gk", { noremap = true, silent = true })

-- Yanking to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste system clipboard" })

-- Make navigating around splits easier
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to split left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to split below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to split above" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to split right" })

-- Put text line-wise
vim.keymap.set(
    { "n", "x" },
    "[p",
    '<CMD>exe "put! " . v: register<CR>',
    { silent = true, desc = "Put yanked text in line above" }
)
vim.keymap.set(
    { "n", "x" },
    "]p",
    '<CMD>exe "put " . v:register<CR>',
    { silent = true, desc = "Put yanked text in line below" }
)

-- Restart Neovim.
vim.keymap.set("n", "<leader>R", "<CMD>restart<CR>", { desc = "Restart Neovim" })

-- Update plugins
vim.keymap.set("n", "<leader>U", "<CMD>lua vim.pack.update()<CR>", { desc = "Pack update" })

-- Tabpage with lazygit
vim.keymap.set("n", "<leader>gg", function()
    vim.cmd("tabedit")
    vim.cmd("setlocal nonumber signcolumn=no")
    vim.fn.jobstart("lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)", {
        on_exit = function()
            vim.cmd("silent! :checktime")
            vim.cmd("silent! :bw")
            vim.cmd("silent! :tabc")
        end,
        term = true,
    })
    vim.cmd("startinsert")
end, { desc = "Lazygit" })
