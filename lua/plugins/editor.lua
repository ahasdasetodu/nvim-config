local gh = require 'config.pack'

vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

vim.pack.add { gh 'nvim-mini/mini.nvim' }

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  -- Avoid conflicts with built-in incremental selection on Neovim>=0.12
  -- See `:help treesitter-incremental-selection`
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

require('mini.pairs').setup()
