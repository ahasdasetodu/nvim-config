vim.pack.add {
  { src = 'https://github.com/akinsho/toggleterm.nvim', version = vim.version.range '*' },
}

require('toggleterm').setup {
  size = 20,
  open_mapping = [[<C-_>]],
  direction = 'horizontal',
  shade_terminals = true,
  float_opts = {
    border = 'curved',
  },
}
