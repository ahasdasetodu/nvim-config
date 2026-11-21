local gh = require 'config.pack'

vim.pack.add { gh 'coder/claudecode.nvim' }

require('claudecode').setup {
  terminal_cmd = vim.fn.exepath 'claude' ~= '' and vim.fn.exepath 'claude' or nil,
  terminal = {
    provider = 'native',
    split_side = 'right',
    split_width_percentage = 0.35,
  },
  diff_opts = {
    open_in_new_tab = false,
  },
}

local map = vim.keymap.set
map('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = '[A]gent: toggle [c]laude' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = '[A]gent: [f]ocus claude' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = '[A]gent: [r]esume session' })
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = '[A]gent: [C]ontinue last session' })
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = '[A]gent: select [m]odel' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = '[A]gent: add current [b]uffer' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = '[A]gent: [s]end selection' })
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = '[A]gent: [a]ccept diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = '[A]gent: [d]eny diff' })

-- Add the file under the cursor in neo-tree.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'neo-tree',
  callback = function(ev) map('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = ev.buf, desc = '[A]gent: add file to claude' }) end,
})
