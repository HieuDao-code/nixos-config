-- Run and interact with tests
_G.Config.later(function()
    vim.pack.add({
        { src = "https://github.com/nvim-neotest/nvim-nio" },
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/antoinemadec/fixcursorhold.nvim" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
        { src = "https://github.com/nvim-neotest/neotest-python" },
        { src = "https://github.com/nvim-neotest/neotest", version = vim.version.range("*") },
    })
    require("neotest").setup({
        adapters = {
            require("neotest-python"),
        },
        output = {
            open_on_run = false,
        },
        output_panel = {
            enabled = true,
            open = "botright vsplit",
        },
        status = {
            virtual_text = true,
        },
    })

  -- stylua: ignore start
  vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run(vim.fn.expand '%') end, { desc = 'Run File' })
  vim.keymap.set('n', '<leader>tv', function() require('neotest').run.run({ tree = vim.fn.expand '%', extra_args = { '-vv' } }) end, { desc = 'Run File verbose' })
  vim.keymap.set('n', '<leader>tT', function() require('neotest').run.run(vim.uv.cwd()) end, { desc = 'Run All Test Files' })
  vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run() end, { desc = 'Run Nearest' })
  vim.keymap.set('n', '<leader>tl', function() require('neotest').run.run_last() end, { desc = 'Run Last' })
  vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Toggle Summary' })
  vim.keymap.set('n', '<leader>to', function() require('neotest').output.open { enter = true, auto_close = true } end, { desc = 'Show Output' })
  vim.keymap.set('n', '<leader>tO', function() require('neotest').output_panel.toggle() end, { desc = 'Toggle Output Panel' })
  vim.keymap.set('n', '<leader>tS', function() require('neotest').run.stop() end, { desc = 'Stop' })
  vim.keymap.set('n', '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand '%') end, { desc = 'Toggle Watch' })
  vim.keymap.set('n', '<leader>td', function() require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' } end, { desc = 'Debug current file' })
end)
