local gh = require 'config.pack'

vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
}

vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', { desc = '[T]oggle rendered [m]arkdown' })
