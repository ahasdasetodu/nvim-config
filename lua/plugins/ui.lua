local gh = require 'config.pack'

vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>g', group = 'Git' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>p', group = 'Python' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

vim.pack.add { gh 'rebelot/kanagawa.nvim' }
require('kanagawa').setup {
  compile = false,
  undercurl = true,
  commentStyle = { italic = true },
  functionStyle = {},
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = {},
  transparent = false,
  dimInactive = true,
  terminalColors = true,
  colors = {
    palette = {},
    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  },
  overrides = function(colors) return {} end,
  theme = 'wave',
  background = {
    dark = 'wave',
    light = 'lotus',
  },
}

vim.cmd 'colorscheme kanagawa'

vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- mini.nvim itself is added in plugins.editor, which loads first.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

require('mini.tabline').setup()
