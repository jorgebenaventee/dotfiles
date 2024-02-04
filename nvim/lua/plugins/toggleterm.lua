require('toggleterm').setup{}

vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=horizontal<CR>', {desc = 'Open terminal'})
vim.keymap.set('t', '<leader>tt', '<C-\\><C-n>:ToggleTerm direction=horizontal<CR>', {desc = 'Open terminal'})
vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', {desc = 'Open vertical terminal'})
