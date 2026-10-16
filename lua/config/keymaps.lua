-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- My keymaps:
vim.keymap.set('n', '<A-l>', '<Cmd>bnext<CR>', { desc = "Previous buffer"})
vim.keymap.set('n', '<A-h>', '<Cmd>bprev<CR>', { desc = "Next buffer"})
vim.keymap.set('n', '<leader>bd', '<Cmd>bdelete<CR>', { desc = "Close buffer"} )

vim.keymap.set({'n', 'i'}, '<C-s>', '<Cmd>:w<CR>', { desc = "Save"})
vim.keymap.set({'n', 'v', 'i'}, '<C-a>', '<Esc>ggVG')
-- Toggle Diffview for the working tree against the index.
-- Closes it when this tab is already a Diffview tab.
vim.keymap.set('n', '<leader>gd', function()
  local view = require('diffview.lib').get_current_view()
  if view then
    vim.cmd 'DiffviewClose'
  else
    vim.cmd 'DiffviewOpen'
  end
end, { desc = 'Toggle Diffview' })

vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' })

-- Open git history for the specific file you are currently viewing
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Diff History (Current File)' })

-- Open git history for the entire project branch
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = 'Diff History (Branch)' })

