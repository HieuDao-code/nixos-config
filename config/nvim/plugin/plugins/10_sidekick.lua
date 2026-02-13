-- Your Neovim AI sidekick
_G.Config.later(function()
    vim.pack.add({ { src = "https://github.com/folke/sidekick.nvim", version = vim.version.range("*") } })
    require("sidekick").setup({})

    vim.keymap.set("n", "<TAB>", function()
        -- If there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
            return "<TAB>" -- Fallback to normal tab
        end
    end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
end)
